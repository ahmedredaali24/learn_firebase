import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:wael/home/home/home_screen.dart';
import 'package:wael/home/home/notes/view_note.dart';
import 'package:wael/home/utils/primary_button.dart';

class AddNote extends StatefulWidget {
  final String id;

  const AddNote({super.key, required this.id});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController note = TextEditingController();
  TextEditingController sub = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  CollectionReference notes =
      FirebaseFirestore.instance.collection("categories");
  bool? isSelectedImage;

  File? file;
  String? url;

  @override
  void dispose() {
    ///فائدة dispose() هي التأكد من تحرير الموارد المستخدمة بشكل صحيح عندما لم تعد هناك حاجة إليها، مما يحسن من أداء التطبيق ويقلل من احتمال حدوث مشاكل مثل تسرب الذاكرة.
    super.dispose();
    note.dispose();
    sub.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                style: const TextStyle(fontSize: 20),
                maxLength: 15,
                validator: (value) {
                  if (value!.isEmpty || value.trim().isEmpty) {
                    return "please add your note  ";
                  }
                  return null;
                },
                controller: note,
                decoration: const InputDecoration(
                  hintText: "note name",
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
                  return null;
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
                  addCategory(context);
                },
                text: "add note",
                width: 200,
              ),
              const SizedBox(
                height: 15,
              ),
              PrimaryButton(
                onTap: () async {
                 await getImage();
                },
                text: "save  image",
                width: 200,
                btnColor: url == null ? Colors.blue : Colors.green,
              )
            ]),
          )),
    );
  }

  addCategory(BuildContext context) async {
    await notes
        .doc(widget.id)
        .collection("notes")
        .add({"name": note.text, "sub": sub.text,"url":url??"none"}).then((value) {
      print("added suc");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ViewNoteScreen(
                categoryName: "",
                categoryId: widget.id,
              )));
    }).catchError((e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'error',
        desc: '$e',
        btnOkOnPress: () {},
      ).show();
    });
  }

  getImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) {
      return;
    }
    file = File(xFile.path);

    var imageName = basename(xFile.path);
    var refS = FirebaseStorage.instance.ref(imageName);
    await refS.putFile(file!);
    url = await refS.getDownloadURL();
    setState(() {});
  }
}
