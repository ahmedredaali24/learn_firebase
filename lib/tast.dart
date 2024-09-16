import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  static const String routeName = "test";

  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("test"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? myToken=await FirebaseMessaging.instance.getToken();
            print("========================================");
            print(myToken);
          },
          child: Text("get token"),
        ),
      ),
    );
  }
}
