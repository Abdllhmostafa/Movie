import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final bool readOnly;

  const CustomTextField({
    super.key,
    this.initialValue,
    this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: keyboardType,
      cursorColor: AppColors.gold,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.hintColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 12.w),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 26.sp,
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 54.w,
          minHeight: 26.h,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: AppColors.gold,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
