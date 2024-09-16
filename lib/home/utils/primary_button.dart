import 'package:flutter/material.dart';

import 'app_color.dart';
class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? btnColor;
  final Color? fontColor;

  const PrimaryButton(
      {super.key,
        required this.onTap,
        required this.text,
        this.height,
        this.width,
        this.fontSize,
        this.btnColor,
        this.fontColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: btnColor ?? AppColors.kPrimary,
            borderRadius: BorderRadius.circular(23)),
        child: Text(
          text,
          style: TextStyle(
              color: fontColor ?? AppColors.kLightWhite,
              fontSize: fontSize ?? 20),
        ),
      ),
    );
  }
}