import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.home_sharp,
            activeIcon: Icons.home_sharp,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.search_rounded,
            activeIcon: Icons.search_rounded,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.explore,
            activeIcon: Icons.explore,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    double size = 28,
  }) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap?.call(index),
          borderRadius: BorderRadius.circular(24.r),
          child: Center(
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppColors.gold
                  : AppColors.white.withValues(alpha: 0.6),
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
