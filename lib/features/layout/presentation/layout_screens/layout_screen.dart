import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/presentation/layout_screens/browse_tab.dart';
import 'package:movie_app/features/layout/presentation/layout_screens/home_screen.dart';
import 'package:movie_app/features/layout/presentation/profile/manager/profile_cubit.dart';
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
  late final ProfileCubit _profileCubit;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchTab(),
    BrowseTab(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _profileCubit = ProfileCubit()..getProfileData();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        // Using Stack inside the body to let screens pass behind the floating navbar
        body: Stack(
          children: [
            // 1. Your tab screens fill the whole screen space
            Positioned.fill(
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),

            // 2. Floating Custom Bottom NavBar anchored at the bottom
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,

              child: BottomNavBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  if (index == 3) {
                    _profileCubit.getProfileData();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
