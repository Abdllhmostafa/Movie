import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class AuthPromptRow extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onTap;
  final Color questionColor;
  final Color actionColor;
  final double? fontSize;

  const AuthPromptRow({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onTap,
    this.questionColor = Colors.white,
    this.actionColor = AppColors.gold,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? 14.sp;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            questionText,
            style: TextStyle(
              fontSize: effectiveFontSize,
              fontWeight: FontWeight.w400,
              color: questionColor,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            child: Text(
              actionText,
              style: TextStyle(
                fontSize: effectiveFontSize,
                fontWeight: FontWeight.bold,
                color: actionColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
