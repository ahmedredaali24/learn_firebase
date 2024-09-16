import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  static const String routeName = "Users";

  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  var user = FirebaseFirestore.instance.collection("users");
  Stream userStream =
      FirebaseFirestore.instance.collection("users").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Filter"),
        ),
        body: StreamBuilder(
            stream: userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("error"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("loading"),
                );
              }
              List data = snapshot.data.docs;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        transactions("${data[index].id}");
                      },
                      child: ListTile(
                        trailing: Text("${data[index]['price']}",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 25)),
                        title: Text("${data[index]['name']}",
                            style: const TextStyle(fontSize: 15)),
                        subtitle: Text("age  ${data[index]['age']}",
                            style: const TextStyle(fontSize: 15)),
                      ),
                    );
                  });
            }));
  }

  transactions(String id) async {
    try {
      DocumentReference documentReference = user.doc(id);
      return FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          var snapshotData = snapshot.data();
          if (snapshotData is Map<String, dynamic>) {
            int num = snapshotData['price'] + 100;
            transaction.update(documentReference, {"price": num});
          }
        }
      }).then((value) {});
    } catch (e) {
      print(e);
    }
  }

// transaction(String id) async {
//   DocumentReference documentReference = user.doc(id);
//   return FirebaseFirestore.instance.runTransaction(
//     (transaction) async {
//       DocumentSnapshot documentSnapshot =
//           await transaction.get(documentReference);
//       if (documentSnapshot.exists) {
//         var snapShotData = documentSnapshot.data();
//         if (snapShotData is Map<String, dynamic>) {
//           int money = snapShotData['price'] + 100;
//           transaction.update(documentReference, {"price": money});
//         }
//       }
//     },
//   ).then((value) {
//     Navigator.of(context)
//         .pushNamedAndRemoveUntil(Users.routeName, (route) => false);
//   });
// }
}
