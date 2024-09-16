import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'app_color.dart';
class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;

  const SocialButton(
      {super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 59,
        width: 59,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.kLightWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 32,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(0.25))
            ]),
        child: SvgPicture.asset(

          icon,
        ),
      ),
    );
  }
}