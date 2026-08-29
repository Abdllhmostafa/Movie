import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class AuthPromptRow extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onTap;
  final Color questionColor;
  final Color actionColor;
  final double fontSize;

  const AuthPromptRow({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onTap,
    this.questionColor = AppColors.textGrey,
    this.actionColor = AppColors.gold,
    this.fontSize = 15,
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
            color: questionColor,
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
                fontWeight: FontWeight.bold,
                color: actionColor,
                decoration: TextDecoration.underline,
                decorationColor: actionColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
