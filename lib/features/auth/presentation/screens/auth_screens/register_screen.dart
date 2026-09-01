import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/states/base_state.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_state.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_button_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_prompt_row.dart';
import 'package:movie_app/features/auth/presentation/widgets/register_form_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/route_logo_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegisterPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            rePassword: _rePasswordController.text,
            phone: _phoneController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.white,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.registerState != current.registerState,
          listener: (context, state) {
            if (state.registerState is SuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration Successful! Welcome to Route Movies!'),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state.registerState is ErrorState) {
              final error =
                  (state.registerState as ErrorState).message ??
                  'Registration failed';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.registerState is LoadingState;

            return SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const RouteLogoWidget(iconSize: 52, fontSize: 26),
                    const SizedBox(height: 24),
                    RegisterFormWidget(
                      formKey: _formKey,
                      nameController: _nameController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      rePasswordController: _rePasswordController,
                      onSubmitted: () => _onRegisterPressed(context),
                    ),
                    const SizedBox(height: 30),
                    AuthButtonWidget(
                      text: 'Create Account',
                      isLoading: isLoading,
                      onPressed: () => _onRegisterPressed(context),
                    ),
                    const SizedBox(height: 20),
                    AuthPromptRow(
                      questionText: 'Already have an account?',
                      actionText: 'Sign In',
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
