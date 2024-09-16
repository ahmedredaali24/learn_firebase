import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageCh extends StatefulWidget {
  static const String routeName = "ImageCh";

  const ImageCh({super.key});

  @override
  State<ImageCh> createState() => _ImageChState();
}

class _ImageChState extends State<ImageCh> {
  File? file;
  String? url;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Filter"),
        ),
        body: Column(
          children: [
            MaterialButton(
                onPressed: () {
                  getImage();
                },
                child: const Text("chooseImage")),
            if (url != null)
              Image.network(
                url!,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              )
          ],
        ));
  }
}
