import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/screens/profile/widgets/movie_card.dart';
import 'package:movie_app/features/auth/presentation/screens/profile/widgets/profile_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyMovies = [
      AppAssets.movie1,
      AppAssets.movie2,
      AppAssets.movie3,
      AppAssets.movie4,
      AppAssets.movie5,
      AppAssets.movie6,
      AppAssets.movie7,
      AppAssets.movie8,
      AppAssets.movie9,
      AppAssets.movie10,
      AppAssets.movie11,
      AppAssets.movie12,
    ];

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.profileBkGround,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 52.h,
                        bottom: 23.h,
                        left: 24.w,
                        right: 26.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 118.w,
                                height: 118.h,
                                child: CircleAvatar(
                                  radius: 50.r,
                                  backgroundImage: AssetImage(AppAssets.gamer9),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "John Safwat",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "12",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "Wish List",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "10",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "History",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: ProfileButton(
                              text: "Edit Profile",
                              backgroundColor: AppColors.yellow,
                              textColor: AppColors.black,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteName.updateProfileScreen,
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          ProfileButton(
                            text: "Exit",
                            backgroundColor: AppColors.red,
                            textColor: AppColors.white,
                            icon: Icons.logout,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              SliverAppBar(
                backgroundColor: AppColors.profileBkGround,
                elevation: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: 0,
                pinned: true,
                primary: false,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(88.h),
                  child: Container(
                    color: AppColors.profileBkGround,
                    child: TabBar(
                      indicatorColor: AppColors.yellow,
                      indicatorWeight: 3.h,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.white,
                      tabs: [
                        Tab(
                          height: 84.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.watchlist,
                                width: 24.w,
                                height: 24.h,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "Watch List",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          height: 84.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.history,
                                width: 24.w,
                                height: 24.h,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "History",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                Center(
                  child: Lottie.asset(
                    AppAssets.entertainment,
                    width: 150.w,
                    height: 150.h,
                    fit: BoxFit.contain,
                  ),
                ),
                GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: historyMovies.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 122 / 180,
                  ),
                  itemBuilder: (context, index) {
                    return MovieCard(
                      imagePath: historyMovies[index],
                      rating: "7.7",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
