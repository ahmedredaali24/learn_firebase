import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'app_color.dart';
class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String icon;
  final Color iconColor;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AuthField(
      {super.key,
        required this.iconColor,
        required this.controller,
        required this.icon,
        required this.hintText,
        this.validator,
        this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      keyboardType: keyboardType,
      decoration: InputDecoration(
          hintText: hintText,
          fillColor: AppColors.kLightWhite2,
          filled: true,
          hintStyle: const TextStyle(color: Colors.grey),
          errorMaxLines: 3,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration:
              BoxDecoration(shape: BoxShape.circle, color: iconColor),
              child: SvgPicture.asset(icon),
            ),
          )),
    );
  }
}