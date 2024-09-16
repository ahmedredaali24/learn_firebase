import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wael/home/home/home_screen.dart';

import 'package:wael/home/home/notes/add_note.dart';
import 'package:wael/home/home/notes/edit_note.dart';

class ViewNoteScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const ViewNoteScreen(
      {super.key, required this.categoryName, required this.categoryId});

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");

  List data = [];

  readDateNow() async {
    QuerySnapshot querySnapshot =
        await categories.doc(widget.categoryId).collection("notes").get();
    data.addAll(querySnapshot.docs);
    print(data);
    print("jknknkkj");
    setState(() {});
  }

  @override
  void initState() {
    readDateNow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Note : ${widget.categoryName}"),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPOp) async {
            Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName, (route) => false);
            await Future.value(false);
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              MaterialButton(
                padding: const EdgeInsets.all(15),
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddNote(id: widget.categoryId)));
                },
                child: const Text(
                  "add your note",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, i) {
                      return const Divider(
                        color: Colors.orange,
                        thickness: 2,
                      );
                    },
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditNote(
                                        categoryId: widget.categoryId,
                                        id: "${data[index].id}",
                                        note: "${data[index]['name']}",
                                        sub: "${data[index]['sub']}",
                                      )));
                        },
                        trailing: IconButton(
                          onPressed: () async {
                            await categories
                                .doc(widget.categoryId)
                                .collection("notes")
                                .doc("${data[index].id}")
                                .delete()
                                .then((value) {
                              setState(() {
                                data.removeAt(index);
                              });
                              print("deletenote");
                            }).catchError((error) {
                              print(error);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          "${data[index]['name']}",
                          style: TextStyle(fontSize: 25),
                        ),
                        leading: data[index]['url'] == "none"
                            ? Icon(Icons.error_outline)
                            : Image.network(
                                "${data[index]['url']}",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                        subtitle: Text(
                          // overflow: TextOverflow.ellipsis,
                          "${data[index]['sub']}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
