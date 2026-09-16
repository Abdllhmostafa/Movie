import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_state.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_button_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_prompt_row.dart';
import 'package:movie_app/features/auth/presentation/widgets/google_logo_icon.dart';
import 'package:movie_app/features/auth/presentation/widgets/language_switch_widget.dart';
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

  void _navigateToForgotPassword(BuildContext context) {
    Navigator.of(context).pushNamed(RouteName.forgotPassword);
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
              final welcome = context.tr('welcome_back');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$welcome${state.user.name != null ? ", ${state.user.name}" : ""}!',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pushReplacementNamed(context, RouteName.layout);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.trError(state.errorMessage)),
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
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10.h),
                      const RouteLogoWidget(
                        iconSize: 64,
                      ),
                      SizedBox(height: 32.h),
                      LoginFormWidget(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onSubmitted: () => _onLoginPressed(context),
                        onForgotPassword: () =>
                            _navigateToForgotPassword(context),
                      ),
                      SizedBox(height: 24.h),
                      AuthButtonWidget(
                        text: context.tr('login'),
                        fontSize: 20.sp,
                        isLoading: isLoading,
                        onPressed: () => _onLoginPressed(context),
                      ),
                      SizedBox(height: 18.h),
                      AuthPromptRow(
                        questionText: context.tr('dont_have_account'),
                        actionText: context.tr('create_one'),
                        onTap: () => _navigateToRegister(context),
                      ),
                      SizedBox(height: 22.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 92.w,
                            height: 1.2,
                            color: AppColors.gold,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Text(
                              context.tr('or'),
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            width: 92.w,
                            height: 1.2,
                            color: AppColors.gold,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      AuthButtonWidget(
                        customIcon: const GoogleLogoIcon(size: 24),
                        text: context.tr('login_with_google'),
                        fontSize: 18.sp,
                        isLoading: false,
                        onPressed: () => _onGoogleSignIn(context),
                      ),
                      SizedBox(height: 32.h),
                      const LanguageSwitchWidget(),
                      SizedBox(height: 12.h),
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
