import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wael/home/home/home_screen.dart';
import 'package:wael/home/utils/primary_button.dart';


class AddCategory extends StatefulWidget {
  static const String routeName = "/AddCategory";

  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add categories"),
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
                  hintText: "add category",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              PrimaryButton(
                onTap: () {
                  addCategory();
                },
                text: "add category",
                width: 200,
              )
            ]),
          )),
    );
  }

  addCategory() async {
    await categories.add({
      "name": categoryName.text,
      "id": FirebaseAuth.instance.currentUser!.uid
    }).then((value) {
      print("added suc");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
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
}
