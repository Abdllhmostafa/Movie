import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String initialValue;
  final IconData icon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.initialValue,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      initialValue: controller == null ? initialValue : null,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: AppColors.white,
          size: 26.sp,
        ),
        filled: true,
        fillColor: AppColors.bottomNavigatorBar,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
      ),
    );
  }
}