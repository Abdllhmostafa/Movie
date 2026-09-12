import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const SearchInputField({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: AppColors.white, fontSize: 16.sp),
      cursorColor: AppColors.gold,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: AppColors.white.withValues(alpha: 0.7)),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, color: AppColors.white.withValues(alpha: 0.7)),
                onPressed: onClear,
              )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.white.withValues(alpha: 0.5),
          fontSize: 16.sp,
        ),
        fillColor: AppColors.inputFill,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.gold.withValues(alpha: 0.1),
            width: 1,
          ),
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
