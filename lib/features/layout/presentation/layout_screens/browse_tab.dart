import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/presentation/widgets/category_card.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  static const List<Map<String, dynamic>> _genres = [
    {'name': 'Action', 'icon': Icons.flash_on_rounded},
    {'name': 'Adventure', 'icon': Icons.explore_rounded},
    {'name': 'Animation', 'icon': Icons.animation_rounded},
    {'name': 'Comedy', 'icon': Icons.sentiment_very_satisfied_rounded},
    {'name': 'Crime', 'icon': Icons.local_police_rounded},
    {'name': 'Drama', 'icon': Icons.theater_comedy_rounded},
    {'name': 'Horror', 'icon': Icons.nightlight_round},
    {'name': 'Sci-Fi', 'icon': Icons.rocket_launch_rounded},
    {'name': 'Romance', 'icon': Icons.favorite_rounded},
    {'name': 'Thriller', 'icon': Icons.psychology_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse Categories',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Explore movies by your favorite genres',
              style: TextStyle(color: AppColors.textGrey, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(bottom: 16.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 1.5,
                ),
                itemCount: _genres.length,
                itemBuilder: (context, index) {
                  final item = _genres[index];
                  return CategoryCard(
                    name: item['name'] as String,
                    icon: item['icon'] as IconData,
                    onTap: () {
                      // Navigate or filter by category
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
