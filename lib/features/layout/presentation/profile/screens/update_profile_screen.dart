import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/presentation/profile/manager/profile_cubit.dart';
import 'package:movie_app/features/layout/presentation/profile/manager/profile_state.dart';
import 'package:movie_app/features/layout/presentation/widgets/avatar_picker_sheet.dart';
import 'package:movie_app/features/layout/presentation/widgets/custom_text_field.dart';
import 'package:movie_app/features/layout/presentation/widgets/profile_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileData(),
      child: const _UpdateProfileScreenBody(),
    );
  }
}

class _UpdateProfileScreenBody extends StatefulWidget {
  const _UpdateProfileScreenBody();

  @override
  State<_UpdateProfileScreenBody> createState() =>
      _UpdateProfileScreenBodyState();
}

class _UpdateProfileScreenBodyState extends State<_UpdateProfileScreenBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedAvatar = AppAssets.gamer9;
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadInitialDataDirectly();
  }

  Future<void> _loadInitialDataDirectly() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    String phone = "";
    String name = "";
    String avatar = "";

    if (user != null) {
      phone =
          prefs.getString('user_phone_${user.uid}') ??
          prefs.getString('user_phone') ??
          prefs.getString('pending_phone') ??
          (user.phoneNumber ?? "");

      name = (user.displayName != null && user.displayName!.isNotEmpty)
          ? user.displayName!
          : (prefs.getString('user_name_${user.uid}') ??
                prefs.getString('user_name') ??
                prefs.getString('pending_name') ??
                (user.email?.split('@').first ?? ""));

      avatar = (user.photoURL != null && user.photoURL!.isNotEmpty)
          ? user.photoURL!
          : (prefs.getString('user_avatar_${user.uid}') ??
                prefs.getString('user_avatar') ??
                AppAssets.gamer9);
    }

    if (mounted) {
      setState(() {
        if (_phoneController.text.isEmpty && phone.isNotEmpty) {
          _phoneController.text = phone;
        }
        if (_nameController.text.isEmpty && name.isNotEmpty) {
          _nameController.text = name;
        }
        if (_selectedAvatar == AppAssets.gamer9 && avatar.isNotEmpty) {
          _selectedAvatar = avatar;
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        final argName = args['name'] as String?;
        final argAvatar = args['avatar'] as String?;
        final argPhone = args['phone'] as String?;
        if (argName != null && argName.isNotEmpty && argName != "User") {
          _nameController.text = argName;
        }
        if (argAvatar != null && argAvatar.isNotEmpty) {
          _selectedAvatar = argAvatar;
        }
        if (argPhone != null && argPhone.isNotEmpty) {
          _phoneController.text = argPhone;
        }
      }
      _isDataInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text(
          "Delete Account",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
          style: TextStyle(color: AppColors.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<ProfileCubit>().deleteAccount();
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadedState) {
          if (state.name.isNotEmpty &&
              state.name != "User" &&
              _nameController.text.isEmpty) {
            _nameController.text = state.name;
          }
          if (state.phone.isNotEmpty && _phoneController.text.isEmpty) {
            _phoneController.text = state.phone;
          }
          if (state.avatar.isNotEmpty && _selectedAvatar == AppAssets.gamer9) {
            setState(() {
              _selectedAvatar = state.avatar;
            });
          }
        } else if (state is ProfileUpdateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ProfilePasswordResetSentState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password reset email sent to ${state.email}"),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is ProfileDeleteAccountSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.login,
            (route) => false,
          );
        } else if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoadingState;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(
              "Pick Avatar",
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 36.h),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(75.r),
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
                    child: ClipOval(
                      child: _selectedAvatar.startsWith('http')
                          ? Image.network(
                              _selectedAvatar,
                              width: 150.w,
                              height: 150.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                AppAssets.gamer9,
                                width: 150.w,
                                height: 150.h,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              _selectedAvatar,
                              width: 150.w,
                              height: 150.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 150.w,
                                height: 150.h,
                                color: AppColors.cardBackground,
                                child: Icon(
                                  Icons.person,
                                  size: 60.sp,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 36.h),
                CustomTextField(
                  controller: _nameController,
                  hintText: "Enter your name",
                  icon: Icons.person,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _phoneController,
                  hintText: "Enter your phone number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () => context
                              .read<ProfileCubit>()
                              .sendPasswordResetEmail(),
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 120.h),
                ProfileButton(
                  onPressed: isLoading
                      ? () {}
                      : () => _showDeleteAccountDialog(context),
                  text: "Delete Account",
                  backgroundColor: AppColors.btnBgColor,
                  textColor: AppColors.white,
                ),
                SizedBox(height: 20.h),
                ProfileButton(
                  onPressed: isLoading
                      ? () {}
                      : () {
                          final name = _nameController.text.trim();
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Name cannot be empty"),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }
                          context.read<ProfileCubit>().updateProfileData(
                            name: name,
                            avatar: _selectedAvatar,
                            phone: _phoneController.text.trim(),
                          );
                        },
                  text: isLoading ? "Updating..." : "Update Data",
                  backgroundColor: AppColors.gold,
                  textColor: AppColors.background,
                ),
                SizedBox(height: 34.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
