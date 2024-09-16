import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wael/home/auth/login_screen.dart';
import 'package:wael/home/auth/register_screen.dart';
import 'package:wael/home/home/add_category.dart';
import 'package:wael/home/utils/primary_button.dart';

import '../utils/text_form_widget.dart';
import 'edit_category.dart';
import 'notes/view_note.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var categories = FirebaseFirestore.instance.collection("categories");
  List data = [];
  bool changeAppBar = false;
  TextEditingController search = TextEditingController();

  readDate() async {
    QuerySnapshot querySnapshot = await categories
        .where(
          "id",
          isEqualTo: (FirebaseAuth.instance.currentUser!.uid),
        )
        .get();
    List<QueryDocumentSnapshot> query = querySnapshot.docs;
    // await Future.delayed(Duration(seconds: 1));
    data.addAll(query);

    setState(() {});
  }

  @override
  void initState() {
    readDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {
          Navigator.of(context).pushNamed(AddCategory.routeName);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
          actions: [
            InkWell(
              onDoubleTap: (){
                changeAppBar = false;
                setState(() {});
              },
                onLongPress: () {
                  changeAppBar = true;
                  setState(() {});
                },

                child: const Icon(Icons.search)),
            IconButton(
                onPressed: () async {
                  GoogleSignIn google = GoogleSignIn();
                  await google.signOut();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName,
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.white,
                )),
          ],
          title: changeAppBar == false
              ? const Text("Home screen")
              : TextFormField(
                  controller: search,
                )),
      body: data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 5, mainAxisExtent: 160),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewNoteScreen(
                                  categoryId: data[index].id,
                                  categoryName: data[index]['name'],
                                )));
                  },
                  onLongPress: () async {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'error',
                        btnOkText: "delete",
                        btnCancelText: "edite",
                        btnCancelOnPress: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditCategory(
                                name: "${data[index]['name']}",
                                id: "${data[index].id}");
                          }));
                        },
                        btnOkOnPress: () async {
                          QuerySnapshot querySnapshot = await categories
                              .doc(data[index].id)
                              .collection("notes")
                              .get();
                          if (querySnapshot.docs.isEmpty) {
                            await categories.doc(data[index].id).delete();
                            print("delete");
                            setState(() {
                              data.removeAt(index);
                            });
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'error',
                              btnOkOnPress: () {},
                            ).show();
                          }
                        }).show();
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/folder.png",
                            height: 100,
                          ),
                          Text("${data[index]['name']}")
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
