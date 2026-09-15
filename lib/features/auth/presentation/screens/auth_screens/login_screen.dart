import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_state.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_button_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_prompt_row.dart';
import 'package:movie_app/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/route_logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.of(context).pushNamed(RouteName.register);
  }

  void _onGoogleSignIn(BuildContext context) {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final resetEmailController =
        TextEditingController(text: _emailController.text.trim());
    final resetFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Reset Password',
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp),
        ),
        content: Form(
          key: resetFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email and we will send you a password reset link.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: AppColors.white, fontSize: 15.sp),
                cursorColor: AppColors.gold,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle:
                      TextStyle(color: AppColors.textGrey, fontSize: 14.sp),
                  prefixIcon:
                      const Icon(Icons.email_outlined, color: AppColors.gold),
                  fillColor: AppColors.inputFill,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.gold)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(val.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child:
                const Text('Cancel', style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            onPressed: () {
              if (resetFormKey.currentState?.validate() ?? false) {
                final email = resetEmailController.text.trim();
                Navigator.pop(dialogCtx);
                context.read<AuthCubit>().resetPassword(email);
              }
            },
            child: Text('Send Link',
                style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Welcome back${state.user.name != null ? ", ${state.user.name}" : ""}!',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pushReplacementNamed(context, RouteName.layout);
            } else if (state is AuthPasswordResetSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Password reset email sent to ${state.email}. Check your inbox!',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10.h),
                      const RouteLogoWidget(),
                      SizedBox(height: 36.h),
                      LoginFormWidget(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onSubmitted: () => _onLoginPressed(context),
                        onForgotPassword: () =>
                            _showForgotPasswordDialog(context),
                      ),
                      SizedBox(height: 30.h),
                      AuthButtonWidget(
                        text: 'Sign In',
                        isLoading: isLoading,
                        onPressed: () => _onLoginPressed(context),
                      ),
                      SizedBox(height: 24.h),
                      AuthPromptRow(
                        questionText: "Don't have an account?",
                        actionText: "Create Account",
                        onTap: () => _navigateToRegister(context),
                      ),
                      SizedBox(height: 28.h),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              indent: 30.w,
                              color: AppColors.gold,
                              thickness: 1.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              endIndent: 30.w,
                              color: AppColors.gold,
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28.h),
                      AuthButtonWidget(
                        icon: Icons.g_mobiledata,
                        iconSize: 34,
                        text: 'Login with Google',
                        isLoading: false,
                        onPressed: () => _onGoogleSignIn(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
