import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/screens/profile/widgets/avatar_picker_sheet.dart';
import 'package:movie_app/features/auth/presentation/screens/profile/widgets/custom_text_field.dart';
import 'package:movie_app/features/auth/presentation/screens/profile/widgets/profile_button.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),

        title: Text(
          "Pick Avatar",
          style: TextStyle(
            color: AppColors.yellow,
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
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => Padding(
                      padding: EdgeInsets.all(16.r),
                      child: const AvatarPickerSheet(),
                    ),
                  );
                },
                child: SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(AppAssets.gamer9),
                  ),
                ),
              ),
            ),
            SizedBox(height: 36.h),
            CustomTextField(initialValue: "John Safwat", icon: Icons.person),
            SizedBox(height: 20.h),
            CustomTextField(
              initialValue: "01200000000",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 30.h),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: InkWell(
                onTap: () {},
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
            SizedBox(height: 240.h),
            ProfileButton(
              onPressed: () {},
              text: "Delete Account",
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
            ),
            SizedBox(height: 20.h),
            ProfileButton(
              onPressed: () {},
              text: "Update Data",
              backgroundColor: AppColors.yellow,
              textColor: AppColors.black,
            ),
            SizedBox(height: 34.h),
          ],
        ),
      ),
    );
  }
}
