import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wael/home/home/home_screen.dart';
import 'package:wael/home/home/notes/view_note.dart';
import 'package:wael/home/utils/primary_button.dart';

class EditNote extends StatefulWidget {
  final String id;
  final String note;
  final String sub;
  final String categoryId;

  const EditNote(
      {super.key,
      required this.id,
      required this.note,
      required this.sub,
      required this.categoryId});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController note = TextEditingController();
  TextEditingController sub = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  CollectionReference notes =
      FirebaseFirestore.instance.collection("categories");

  @override
  void dispose() {
    ///فائدة dispose() هي التأكد من تحرير الموارد المستخدمة بشكل صحيح عندما لم تعد هناك حاجة إليها، مما يحسن من أداء التطبيق ويقلل من احتمال حدوث مشاكل مثل تسرب الذاكرة.
    super.dispose();
    note.dispose();
    sub.dispose();
  }

  @override
  void initState() {
    note.text = widget.note;
    sub.text = widget.sub;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("edit Note"),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty || value.trim().isEmpty) {
                    return "please add your note  ";
                  }
                },
                controller: note,
                decoration: const InputDecoration(
                  hintText: "add note",
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(fontSize: 22),
                maxLength: 300,
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty || value.trim().isEmpty) {
                    return "please add your note  ";
                  }
                },
                controller: sub,
                decoration: const InputDecoration(
                  hintText: "note subtitle",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              PrimaryButton(
                onTap: () {
                  editCategory();
                },
                text: "edit note",
                width: 200,
              )
            ]),
          )),
    );
  }

  editCategory() async {
    await notes
        .doc(widget.categoryId)
        .collection("notes")
        .doc(widget.id)
        .update({"name": note.text, "sub": sub.text}).then((value) {
      print("update");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ViewNoteScreen(
                categoryName: "",
                categoryId: widget.id,
              )));
    }).catchError((onError) => print(onError));
    setState(() {});
  }
}
