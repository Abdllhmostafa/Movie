import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:movie_app/features/auth/presentation/widgets/forgot_password_widget.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onSubmitted;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    this.onForgotPassword,
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
            hint: context.tr('email'),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.email,
              color: AppColors.white,
              size: 24.sp,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.tr('please_enter_email');
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return context.tr('please_enter_valid_email');
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            hint: context.tr('password'),
            controller: passwordController,
            isPassword: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmitted?.call(),
            prefixIcon: Icon(
              Icons.lock,
              color: AppColors.white,
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
          SizedBox(height: 12.h),
          ForgotPasswordWidget(onTap: onForgotPassword),
        ],
      ),
    );
  }
}
