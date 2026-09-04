import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/screens/onboarding/onboarding_model.dart';
import 'onboarding_button.dart';

class OnboardingBottomContent extends StatelessWidget {
  const OnboardingBottomContent({
    super.key,
    required this.page,
    required this.onNext,
    required this.onPrevious,
  });

  final OnboardingModel page;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 24.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.textDark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              page.supTitle ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.textGrey,
                fontSize: 20.sp,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                children: [
                  OnboardingButton(
                    text: page.textBttn,
                    onTap: onNext,
                  ),

                  if (page.secondTextBttn != null) ...[
                    SizedBox(height: 12.h),

                    OnboardingButton(
                      text: page.secondTextBttn!,
                      onTap: onPrevious,
                      outlined: true,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}