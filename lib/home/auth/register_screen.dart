import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wael/home/auth/login_screen.dart';
import 'package:wael/home/home/home_screen.dart';

import '../utils/images.dart';
import '../utils/primary_button.dart';
import '../utils/social_button.dart';
import '../utils/text_form_widget.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/RegisterScreen";

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController usernameController =
      TextEditingController(text: "ahmed");

  final TextEditingController mailController =
      TextEditingController(text: "ahmed@gmail.com");

  final TextEditingController passwordController =
      TextEditingController(text: "Aa123456789ahmed");

  bool isPasswordStrong(String password) {
    if (password.length < 8) {
      return false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFFDFDFD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 56),
              const Center(
                  child: Text('Sign Up',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
              const SizedBox(height: 5),
              const Text('Welcome back! Please enter your details',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      color: Colors.black)),
              const SizedBox(height: 68),
              AuthField(
                  iconColor: const Color(0xFFFFEADB),
                  controller: usernameController,
                  keyboardType: TextInputType.name,
                  icon: AppAssets.kUser,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Full Name';
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return 'Full Name should not contain digits';
                    }
                    return null;
                  },
                  hintText: 'Full Name'),
              const SizedBox(height: 16),
              AuthField(
                  iconColor: const Color(0xFFEBD9EF),
                  controller: mailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: AppAssets.kMail,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!value.isEmail) {
                      return 'Please enter a valid email address';
                    }

                    return null;
                  },
                  hintText: 'Email address'),
              const SizedBox(height: 16),
              AuthField(
                  iconColor: const Color(0xFFE0E9FF),
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  icon: AppAssets.kLock,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (!isPasswordStrong(value)) {
                      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit.';
                    }
                    return null;
                  },
                  hintText: 'Password'),
              const SizedBox(height: 95),
              PrimaryButton(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      register();
                    }
                  },
                  text: 'Sign Up'),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Already have an account',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  PrimaryButton(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    text: 'Sign IN',
                    height: 30,
                    width: 70,
                    fontColor: const Color(0xFF3DB9FF),
                    btnColor: const Color(0xFFF7F7F7),
                    fontSize: 12,
                  )
                ],
              ),
              const SizedBox(height: 56),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(onTap: () {}, icon: AppAssets.kGoogle),
                  const SizedBox(width: 31),
                  SocialButton(onTap: () {}, icon: AppAssets.kFacebook),
                  const SizedBox(width: 31),
                  SocialButton(onTap: () {}, icon: AppAssets.kApple),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  register() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mailController.text,
        password: passwordController.text,
      );
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'error',
          desc: 'The password provided is too weak.',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'error',
          desc: 'The account already exists for that email.',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }
}
