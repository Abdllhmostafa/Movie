import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_state.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_button_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_prompt_row.dart';
import 'package:movie_app/features/auth/presentation/widgets/register_form_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/route_logo_widget.dart';
import 'package:movie_app/features/layout/presentation/widgets/avatar_picker_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _selectedAvatar = AppAssets.gamer1;

  final List<String> _avatars = const [
    AppAssets.gamer1,
    AppAssets.gamer2,
    AppAssets.gamer3,
    AppAssets.gamer4,
    AppAssets.gamer5,
    AppAssets.gamer6,
    AppAssets.gamer7,
    AppAssets.gamer8,
    AppAssets.gamer9,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegisterPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text.trim();
      final name = _nameController.text.trim();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_avatar', _selectedAvatar);
      await prefs.setString('user_avatar', _selectedAvatar);
      if (phone.isNotEmpty) {
        await prefs.setString('pending_phone', phone);
        await prefs.setString('user_phone', phone);
      }
      if (name.isNotEmpty) {
        await prefs.setString('pending_name', name);
        await prefs.setString('user_name', name);
      }
      if (context.mounted) {
        context.read<AuthCubit>().register(
          name: name,
          email: _emailController.text.trim(),
          password: _passwordController.text,
          avatar: _selectedAvatar,
        );
      }
    }
  }

  void _onGoogleSignIn(BuildContext context) {
    context.read<AuthCubit>().signInWithGoogle();
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
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is AuthSuccess) {
              final uid = state.user.uID;
              final phone = _phoneController.text.trim();
              final name = _nameController.text.trim();
              SharedPreferences.getInstance().then((prefs) {
                if (name.isNotEmpty) prefs.setString('user_name_$uid', name);
                if (phone.isNotEmpty) {
                  prefs.setString('user_phone_$uid', phone);
                }
                prefs.setString('user_avatar_$uid', _selectedAvatar);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'please login with your recently added email, ${state.user.name ?? "Movie Lover"}!',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pushReplacementNamed(context, RouteName.login);
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
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const RouteLogoWidget(iconSize: 52, fontSize: 26),
                    SizedBox(height: 16.h),
                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(55.r),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => Padding(
                              padding: EdgeInsets.all(16.r),
                              child: AvatarPickerSheet(
                                currentAvatar: _selectedAvatar,
                                onAvatarSelected: (avatar) {
                                  setState(() {
                                    _selectedAvatar = avatar;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                _selectedAvatar,
                                width: 96.w,
                                height: 96.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: const BoxDecoration(
                                color: AppColors.gold,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 16.sp,
                                color: AppColors.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 56.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _avatars.length,
                        separatorBuilder: (_, _) => SizedBox(width: 10.w),
                        itemBuilder: (context, index) {
                          final avatar = _avatars[index];
                          final isSelected = _selectedAvatar == avatar;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAvatar = avatar;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.gold
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              padding: EdgeInsets.all(2.r),
                              child: ClipOval(
                                child: Image.asset(
                                  avatar,
                                  width: 48.w,
                                  height: 48.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    RegisterFormWidget(
                      formKey: _formKey,
                      nameController: _nameController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      rePasswordController: _rePasswordController,
                      onSubmitted: () => _onRegisterPressed(context),
                    ),
                    SizedBox(height: 28.h),
                    AuthButtonWidget(
                      text: 'Create Account',
                      isLoading: isLoading,
                      onPressed: () => _onRegisterPressed(context),
                    ),
                    SizedBox(height: 20.h),
                    AuthPromptRow(
                      questionText: 'Already have an account?',
                      actionText: 'Sign In',
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    SizedBox(height: 24.h),
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
                    SizedBox(height: 24.h),
                    AuthButtonWidget(
                      icon: Icons.g_mobiledata,
                      iconSize: 34,
                      text: 'Sign up with Google',
                      isLoading: false,
                      onPressed: () => _onGoogleSignIn(context),
                    ),
                    SizedBox(height: 20.h),
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
