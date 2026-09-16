import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_state.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_button_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_prompt_row.dart';
import 'package:movie_app/features/auth/presentation/widgets/language_switch_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/register_form_widget.dart';
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
  int _currentAvatarIndex = 0;

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

  String get _selectedAvatar => _avatars[_currentAvatarIndex];

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

  void _previousAvatar() {
    setState(() {
      _currentAvatarIndex =
          (_currentAvatarIndex - 1 + _avatars.length) % _avatars.length;
    });
  }

  void _nextAvatar() {
    setState(() {
      _currentAvatarIndex = (_currentAvatarIndex + 1) % _avatars.length;
    });
  }

  void _openAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.all(16.r),
        child: AvatarPickerSheet(
          currentAvatar: _selectedAvatar,
          onAvatarSelected: (avatar) {
            final index = _avatars.indexOf(avatar);
            if (index != -1) {
              setState(() {
                _currentAvatarIndex = index;
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prevAvatar =
        _avatars[(_currentAvatarIndex - 1 + _avatars.length) % _avatars.length];
    final nextAvatar =
        _avatars[(_currentAvatarIndex + 1) % _avatars.length];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.gold),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(
            context.tr('register'),
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
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
              final successMsg = context.tr('register_success_msg');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$successMsg, ${state.user.name ?? "Movie Lover"}!',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pushReplacementNamed(context, RouteName.login);
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
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8.h),

                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity != null) {
                          if (details.primaryVelocity! < 0) {
                            _nextAvatar();
                          } else if (details.primaryVelocity! > 0) {
                            _previousAvatar();
                          }
                        }
                      },
                      child: SizedBox(
                        height: 160.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            GestureDetector(
                              onTap: _previousAvatar,
                              child: Opacity(
                                opacity: 0.7,
                                child: ClipOval(
                                  child: Image.asset(
                                    prevAvatar,
                                    width: 80.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),

                            GestureDetector(
                              onTap: _openAvatarPicker,
                              child: ClipOval(
                                child: Image.asset(
                                  _selectedAvatar,
                                  width: 135.w,
                                  height: 135.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),

                            GestureDetector(
                              onTap: _nextAvatar,
                              child: Opacity(
                                opacity: 0.7,
                                child: ClipOval(
                                  child: Image.asset(
                                    nextAvatar,
                                    width: 80.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        context.tr('avatar'),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
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
                    SizedBox(height: 24.h),
                    AuthButtonWidget(
                      text: context.tr('create_account'),
                      fontSize: 20.sp,
                      isLoading: isLoading,
                      onPressed: () => _onRegisterPressed(context),
                    ),
                    SizedBox(height: 16.h),
                    AuthPromptRow(
                      questionText: context.tr('already_have_account'),
                      actionText: context.tr('login'),
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    SizedBox(height: 20.h),
                    const LanguageSwitchWidget(),
                    SizedBox(height: 16.h),
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
