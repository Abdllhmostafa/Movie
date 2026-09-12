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
    Navigator.pushReplacementNamed(context, RouteName.layout);
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
                        onForgotPassword: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Forgot Password clicked'),
                            ),
                          );
                        },
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
