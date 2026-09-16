import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:movie_app/features/auth/presentation/widgets/google_logo_icon.dart';
import 'package:movie_app/features/auth/presentation/widgets/language_switch_widget.dart';
import 'package:movie_app/features/auth/presentation/widgets/register_form_widget.dart';
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
  bool _isGoogleAuth = false;

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
    _isGoogleAuth = false;
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
    _isGoogleAuth = true;
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
              if (_isGoogleAuth) {
                Navigator.pushReplacementNamed(context, RouteName.layout);
              }
            } else if (state is AuthRegisterSuccess) {
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

              // Sign out any auto-signed-in firebase session from registration so user must log in
              try {
                FirebaseAuth.instance.signOut();
              } catch (_) {}

              context.read<AuthCubit>().resetState();

              final successMsg = context.tr('register_success_msg');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$successMsg, ${state.user.name ?? "Movie Lover"}!',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );

              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.pushReplacementNamed(context, RouteName.login);
              }
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

                    // Single-row Avatar Carousel Slider
                    CarouselSlider.builder(
                      itemCount: _avatars.length,
                      options: CarouselOptions(
                        height: 145.h,
                        initialPage: _currentAvatarIndex,
                        viewportFraction: 0.36,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.32,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentAvatarIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        final avatar = _avatars[index];
                        final isSelected = _currentAvatarIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentAvatarIndex = index;
                            });
                          },
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isSelected ? 135.w : 85.w,
                              height: isSelected ? 135.h : 85.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.gold,
                                        width: 2.5,
                                      )
                                    : null,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  avatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 6.h),
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
                      isLoading: isLoading && !_isGoogleAuth,
                      onPressed: () => _onRegisterPressed(context),
                    ),
                    SizedBox(height: 16.h),

                    AuthPromptRow(
                      questionText: context.tr('already_have_account'),
                      actionText: context.tr('login'),
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            indent: 30.w,
                            color: AppColors.gold,
                            thickness: 1.2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Text(
                            context.tr('or'),
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            endIndent: 30.w,
                            color: AppColors.gold,
                            thickness: 1.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    AuthButtonWidget(
                      customIcon: const GoogleLogoIcon(size: 24),
                      text: context.tr('register_with_google'),
                      fontSize: 18.sp,
                      isLoading: isLoading && _isGoogleAuth,
                      onPressed: () => _onGoogleSignIn(context),
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
