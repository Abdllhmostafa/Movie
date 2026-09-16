import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/features/auth/presentation/widgets/custom_text_field.dart';

class RegisterFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController rePasswordController;
  final VoidCallback? onSubmitted;

  const RegisterFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.rePasswordController,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            hint: context.tr('name'),
            controller: nameController,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 24.sp,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.tr('please_enter_name');
              }
              if (value.trim().length < 3) {
                return context.tr('name_min_length');
              }
              return null;
            },
          ),
          SizedBox(height: 18.h),
          CustomTextField(
            hint: context.tr('email'),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.white,
              size: 24.sp,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.tr('please_enter_email');
              }
              final emailRegex = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              );
              if (!emailRegex.hasMatch(value.trim())) {
                return context.tr('please_enter_valid_email');
              }
              return null;
            },
          ),
          SizedBox(height: 18.h),
          CustomTextField(
            hint: context.tr('password'),
            controller: passwordController,
            isPassword: true,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white,
              size: 24.sp,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('please_enter_password');
              }
              if (value.length < 6) {
                return context.tr('password_min_length');
              }
              return null;
            },
          ),
          SizedBox(height: 18.h),
          CustomTextField(
            hint: context.tr('confirm_password'),
            controller: rePasswordController,
            isPassword: true,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white,
              size: 24.sp,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('please_confirm_password');
              }
              if (value != passwordController.text) {
                return context.tr('passwords_not_match');
              }
              return null;
            },
          ),
          SizedBox(height: 18.h),
          CustomTextField(
            hint: context.tr('phone_number'),
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmitted?.call(),
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.white,
              size: 24.sp,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.tr('please_enter_phone');
              }
              if (value.trim().length < 10) {
                return context.tr('phone_min_length');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
