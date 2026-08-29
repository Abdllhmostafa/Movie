import 'package:e_commerce_app/core/states/base_state.dart';
import 'package:e_commerce_app/core/theme/app_colors.dart';
import 'package:e_commerce_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:e_commerce_app/features/auth/presentation/manager/auth_state.dart';
import 'package:e_commerce_app/features/auth/presentation/screens/register_screen.dart';
import 'package:e_commerce_app/features/auth/presentation/widgets/auth_button_widget.dart';
import 'package:e_commerce_app/features/auth/presentation/widgets/auth_header_widget.dart';
import 'package:e_commerce_app/features/auth/presentation/widgets/auth_prompt_row.dart';
import 'package:e_commerce_app/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:e_commerce_app/features/auth/presentation/widgets/route_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
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
          listenWhen: (previous, current) =>
              previous.loginState != current.loginState,
          listener: (context, state) {
            if (state.loginState is SuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login Successful! Welcome Back!'),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state.loginState is ErrorState) {
              final error =
                  (state.loginState as ErrorState).message ?? 'Login failed';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.loginState is LoadingState;

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const RouteLogoWidget(),
                      const SizedBox(height: 40),
                      const AuthHeaderWidget(
                        title: 'Welcome Back To Route',
                        subtitle: 'Please sign in with your mail',
                      ),
                      const SizedBox(height: 35),
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
                      const SizedBox(height: 35),
                      AuthButtonWidget(
                        text: 'Login',
                        isLoading: isLoading,
                        onPressed: () => _onLoginPressed(context),
                      ),
                      const SizedBox(height: 30),
                      AuthPromptRow(
                        questionText: "Don’t have an account?",
                        actionText: "Create Account",
                        onTap: () => _navigateToRegister(context),
                      ),
                      const SizedBox(height: 10),
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
