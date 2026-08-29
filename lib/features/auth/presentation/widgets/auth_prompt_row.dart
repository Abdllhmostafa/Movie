import 'package:e_commerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthPromptRow extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onTap;
  final Color textColor;
  final double fontSize;

  const AuthPromptRow({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onTap,
    this.textColor = AppColors.textWhite,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              actionText,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                decoration: TextDecoration.underline,
                decorationColor: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
