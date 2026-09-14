import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/presentation/layout_screens/home_screen.dart';
import 'package:movie_app/features/layout/presentation/profile/screens/profile_screen.dart';
import 'package:movie_app/features/search-tap/presentation/screens/search_tab.dart';
import 'package:movie_app/features/layout/presentation/widgets/bottom_nav_bar.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchTab(),
    _BrowseTabView(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: BottomNavBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Browse / Genres Tab View
// ---------------------------------------------------------------------------
class _BrowseTabView extends StatelessWidget {
  const _BrowseTabView();

  @override
  Widget build(BuildContext context) {
    final genres = [
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
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final item = genres[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 32.sp,
                          color: AppColors.gold,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item['name'] as String,
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
