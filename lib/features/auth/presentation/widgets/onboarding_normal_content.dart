import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/screens/onboarding/onBoarding_model.dart';
import 'onboarding_button.dart';

class OnboardingNormalContent extends StatelessWidget {
  const OnboardingNormalContent({
    super.key,
    required this.page,
    required this.onNext,
  });

  final OnboardingModel page;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 12.w,
      right: 12.w,
      bottom: 50.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 36.sp,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            page.supTitle ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
              fontSize: 20.sp,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20.h),
          OnboardingButton(
            text: page.textBttn,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}