import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({
    super.key,
    required this.text,
    required this.onTap,
    this.outlined = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 52.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: outlined
              ? Colors.transparent
              : AppColors.primaryDark,
          borderRadius: BorderRadius.circular(16.r),
          border: outlined
              ? Border.all(
            color: AppColors.primaryDark,
          )
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: outlined
                  ? AppColors.primaryDark
                  : AppColors.textDark,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}