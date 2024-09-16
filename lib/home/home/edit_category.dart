import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wael/home/home/home_screen.dart';
import 'package:wael/home/utils/primary_button.dart';

import '../utils/text_form_widget.dart';

class EditCategory extends StatefulWidget {
  static const String routeName = "/AddCategory";

  final String name;
  final String id;

  const EditCategory({super.key, required this.name, required this.id});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  // int randomNum = Random().nextInt(1);
  TextEditingController categoryName = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");

  @override
  void dispose() {
    ///فائدة dispose() هي التأكد من تحرير الموارد المستخدمة بشكل صحيح عندما لم تعد هناك حاجة إليها، مما يحسن من أداء التطبيق ويقلل من احتمال حدوث مشاكل مثل تسرب الذاكرة.
    super.dispose();
    categoryName.dispose();
  }

  @override
  void initState() {
    categoryName.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit categories"),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty || value.trim().isEmpty) {
                    return "please add category name ";
                  }
                },
                controller: categoryName,
                decoration: const InputDecoration(
                  hintText: "Edit category",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              PrimaryButton(
                onTap: () {
                  // editCategory();
                  editCategoryBySet();
                },
                text: "edit category",
                width: 200,
              )
            ]),
          )),
    );
  }

  editCategory() async {
    await categories
        .doc(widget.id)
        .update({"name": categoryName.text}).then((value) {
      print("update");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    }).catchError((onError) => print(onError));
  }

  ///ال set تعمل مثل ال update و add
  ///ال add عندما يكون ال id لل doc مختلف او جديد يتم انشاء doc جديد وليس تحديث
  ///ال update يكون عند استخدام نفس الid لل doc ويجب استخدام setOption لاستدعاء كل بيانات الdoc و جعل الmerge  = true
  editCategoryBySet() async {
    await categories.doc(widget.id).set({
      "name": categoryName.text,
    }, SetOptions(merge: true)).then((value) {
      print("update");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    }).catchError((onError) => print(onError));
  }
}
