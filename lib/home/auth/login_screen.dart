import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wael/home/auth/register_screen.dart';

import '../home/home_screen.dart';
import '../utils/app_color.dart';
import '../utils/images.dart';
import '../utils/primary_button.dart';
import '../utils/social_button.dart';
import '../utils/text_form_widget.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController mailController =
      TextEditingController(text: "2017ahmed2abo2@gmail.com");

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
      backgroundColor: AppColors.kLightWhite,
      body: isLoading == true
          ? Center(
              child: const AlertDialog(
                backgroundColor: Colors.yellow,
                title: Text("Loading......"),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 56),
                    const Center(
                        child: Text('Sign In',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    const SizedBox(height: 5),
                    const Center(
                      child: Text('Welcome back! Please enter your details',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                              color: Colors.black)),
                    ),
                    const SizedBox(height: 68),
                    AuthField(
                        iconColor: AppColors.kLavender,
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
                        iconColor: AppColors.kPeriwinkle,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        icon: AppAssets.kLock,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          // if (!isPasswordStrong(value)) {
                          //   return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit.';
                          // }
                          return null;
                        },
                        hintText: 'Password'),
                    const SizedBox(height: 60),
                    PrimaryButton(
                        onTap: () async {
                          login();
                        },
                        text: 'SIgn In'),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        if (mailController.text == "") {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            animType: AnimType.rightSlide,
                            title: 'please enter your email',
                            btnCancelOnPress: () {},
                          ).show();
                          return;
                        }
                        try {
                          FirebaseAuth.instance.sendPasswordResetEmail(
                              email: mailController.text);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'تم ارسال رساله لبريدك الاكتروني',
                            btnCancelOnPress: () {},
                          ).show();
                        } catch (e) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: "$e",
                            btnCancelOnPress: () {},
                          ).show();
                        }
                      },
                      child: const Text("forget your password?",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('Create account',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        PrimaryButton(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RegisterScreen.routeName);
                          },
                          text: 'Sign UP',
                          height: 30,
                          width: 70,
                          fontColor: AppColors.kPrimary,
                          btnColor: AppColors.kLightWhite2,
                          fontSize: 12,
                        )
                      ],
                    ),
                    const SizedBox(height: 56),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton(
                            onTap: () {
                              signInWithGoogle();
                            },
                            icon: AppAssets.kGoogle),
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

  login() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: mailController.text, password: passwordController.text);
        await Future.delayed(Duration(seconds: 3));
        isLoading = false;
        setState(() {});
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName,
            (route) => false,
          );
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'please verified your email',
            btnCancelOnPress: () {},
          ).show();
        }
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'error',
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }

  // login2() async {
  //   if (formKey.currentState!.validate()) {
  //     try {
  //       final credential = await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(
  //               email: mailController.text, password: passwordController.text);
  //       Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'user-not-found') {
  //         print('No user found for that email.');
  //         AwesomeDialog(
  //           context: context,
  //           dialogType: DialogType.info,
  //           animType: AnimType.rightSlide,
  //           title: 'error',
  //           desc: 'No user found for that email.',
  //           btnCancelOnPress: () {},
  //           btnOkOnPress: () {},
  //         ).show();
  //       } else if (e.code == 'wrong-password') {
  //         print('Wrong password provided for that user.');
  //         AwesomeDialog(
  //           context: context,
  //           dialogType: DialogType.info,
  //           animType: AnimType.rightSlide,
  //           title: 'error',
  //           desc: 'Wrong password provided for that user.',
  //           btnCancelOnPress: () {},
  //           btnOkOnPress: () {},
  //         ).show();
  //       }
  //     }catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }
    isLoading = true;
    setState(() {});
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential

    await FirebaseAuth.instance.signInWithCredential(credential);
    await Future.delayed(Duration(seconds: 3));

    isLoading = true;
    setState(() {});
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
  }
}
