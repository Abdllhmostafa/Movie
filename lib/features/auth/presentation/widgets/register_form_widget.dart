import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';
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
            hint: 'Enter your full name',
            controller: nameController,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.gold,
              size: 22,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              if (value.trim().length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Enter your email address',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.gold,
              size: 22,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email address';
              }
              final emailRegex = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              );
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Create a password',
            controller: passwordController,
            isPassword: true,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.gold,
              size: 22,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Confirm your password',
            controller: rePasswordController,
            isPassword: true,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.gold,
              size: 22,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Enter your mobile number',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmitted?.call(),
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.gold,
              size: 22,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your mobile number';
              }
              if (value.trim().length < 10) {
                return 'Enter a valid mobile number (min 10 digits)';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
