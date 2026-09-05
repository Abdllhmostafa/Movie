import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/screens/profile/screens/profile_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    _HomeTabView(),
    _SearchTabView(),
    _BrowseTabView(),
    ProfileScreen(),
  ];

  final List<IconData> _icons = const [
    Icons.home_filled,
    Icons.search_rounded,
    Icons.movie_creation_outlined,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: _screens),
          // Floating Cinematic Bottom Navigation Bar
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 20.h,
            child: Container(
              height: 68.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_icons.length, (index) {
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 16.w : 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _icons[index],
                            size: 24.sp,
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.textGrey,
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Home Tab View
// ---------------------------------------------------------------------------
class _HomeTabView extends StatelessWidget {
  const _HomeTabView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back,',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        'Route Movies',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.gold,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Featured Hero Banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.cardBackground,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: 0.25),
                      AppColors.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 12.w,
                      bottom: 12.h,
                      child: Icon(
                        Icons.movie_filter_rounded,
                        size: 110.sp,
                        color: AppColors.gold.withValues(alpha: 0.15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'FEATURED',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Explore Trending\nBlockbusters',
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: AppColors.gold,
                                size: 18.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '4.9 Rating • HD Cinema',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Section: Trending Now
            _SectionHeader(title: 'Trending Now', onSeeAll: () {}),
            SizedBox(height: 12.h),
            SizedBox(
              height: 180.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: 5,
                separatorBuilder: (context, index) => SizedBox(width: 14.w),
                itemBuilder: (context, index) {
                  return _MovieCardPlaceholder(
                    title: 'Movie ${index + 1}',
                    genre: 'Action • Sci-Fi',
                    rating: '8.${index + 4}',
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),

            // Section: Popular Movies
            _SectionHeader(title: 'Popular Movies', onSeeAll: () {}),
            SizedBox(height: 12.h),
            SizedBox(
              height: 180.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: 5,
                separatorBuilder: (context, index) => SizedBox(width: 14.w),
                itemBuilder: (context, index) {
                  return _MovieCardPlaceholder(
                    title: 'Blockbuster ${index + 1}',
                    genre: 'Drama • Thriller',
                    rating: '9.${index + 1}',
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

// ---------------------------------------------------------------------------
// 2. Search Tab View
// ---------------------------------------------------------------------------
class _SearchTabView extends StatelessWidget {
  const _SearchTabView();

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'Action',
      'Sci-Fi',
      'Drama',
      'Horror',
      'Comedy',
      'Adventure',
      'Animation',
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Movies',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: TextField(
                style: TextStyle(color: AppColors.textWhite, fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: 'Search by title, actor, director...',
                  hintStyle: TextStyle(
                    color: AppColors.hintColor,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.gold,
                    size: 22.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Category Filter Chips
            SizedBox(
              height: 36.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final isSelected = index == 0;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.gold : AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.gold
                            : AppColors.inputBorder,
                      ),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.textDark
                            : AppColors.textGrey,
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30.h),

            // Search Results / Suggestions
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.movie_creation_outlined,
                      size: 64.sp,
                      color: AppColors.textDarkGrey,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Find Your Favorite Movies',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Search through thousands of movies & series',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Browse / Genres Tab View
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
                padding: EdgeInsets.only(bottom: 100.h),
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

// ---------------------------------------------------------------------------
// Shared Helper Widgets
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: Text(
              'See All',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieCardPlaceholder extends StatelessWidget {
  final String title;
  final String genre;
  final String rating;

  const _MovieCardPlaceholder({
    required this.title,
    required this.genre,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              ),
              child: Center(
                child: Icon(
                  Icons.movie_rounded,
                  size: 36.sp,
                  color: AppColors.gold.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  genre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 10.sp),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.gold,
                      size: 13.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      rating,
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
