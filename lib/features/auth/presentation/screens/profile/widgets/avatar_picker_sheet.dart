import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class AvatarPickerSheet extends StatelessWidget {
  final void Function(String avatarPath)? onAvatarSelected;

  const AvatarPickerSheet({
    super.key,
    this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    final avatars = [
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

    const selectedIndex = 8;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.bottomNavigatorBar,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 19.h,
        children: List.generate(avatars.length, (index) {
          final isSelected = index == selectedIndex;
          return InkWell(
            onTap: () {
              onAvatarSelected?.call(avatars[index]);
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.yellow.withValues(alpha: 0.56) : null,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.yellow),
              ),
              padding: EdgeInsets.all(4.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(avatars[index], fit: BoxFit.cover),
              ),
            ),
          );
        }),
      ),
    );
  }
}
