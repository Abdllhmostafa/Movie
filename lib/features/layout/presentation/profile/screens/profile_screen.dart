import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/presentation/profile/manager/profile_cubit.dart';
import 'package:movie_app/features/layout/presentation/profile/manager/profile_state.dart';
import 'package:movie_app/features/layout/presentation/widgets/movie_card.dart';
import 'package:movie_app/features/layout/presentation/widgets/profile_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<ProfileCubit>();
      return const _ProfileScreenBody();
    } catch (_) {
      return BlocProvider(
        create: (context) => ProfileCubit()..getProfileData(),
        child: const _ProfileScreenBody(),
      );
    }
  }
}

class _ProfileScreenBody extends StatelessWidget {
  const _ProfileScreenBody();

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text(
          "Exit App",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to log out of your account?",
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.btnBgColor,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<ProfileCubit>().signOut();
            },
            child: const Text("Exit", style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          current is ProfileSignOutSuccessState || current is ProfileErrorState,
      listener: (context, state) {
        if (state is ProfileSignOutSuccessState) {
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
        final currentUser = FirebaseAuth.instance.currentUser;
        String name =
            (currentUser?.displayName != null &&
                currentUser!.displayName!.trim().isNotEmpty)
            ? currentUser.displayName!.trim()
            : (currentUser?.email?.split('@').first ?? "User");
        String avatar =
            (currentUser?.photoURL != null &&
                currentUser!.photoURL!.trim().isNotEmpty)
            ? currentUser.photoURL!.trim()
            : AppAssets.gamer9;
        String phone = currentUser?.phoneNumber ?? "";
        List<Map<String, String>> wishlistMovies = [];
        List<Map<String, String>> watchlistMovies = [];
        List<Map<String, String>> historyMovies = [];

        if (state is ProfileLoadedState) {
          name = state.name;
          avatar = state.avatar;
          phone = state.phone;
          wishlistMovies = state.wishlistMovies;
          watchlistMovies = state.watchlistMovies;
          historyMovies = state.historyMovies;
        }

        return DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 40.h,
                            bottom: 23.h,
                            left: 24.w,
                            right: 26.w,
                          ),
                          child: Row(
                            spacing: 16.w,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: avatar.startsWith('http')
                                          ? Image.network(
                                              avatar,
                                              width: 118.w,
                                              height: 118.h,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Image.asset(
                                                AppAssets.gamer9,
                                                width: 118.w,
                                                height: 118.h,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.asset(
                                              avatar,
                                              width: 118.w,
                                              height: 118.h,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                width: 118.w,
                                                height: 118.h,
                                                color: AppColors.cardBackground,
                                                child: Icon(
                                                  Icons.person,
                                                  size: 50.sp,
                                                  color: AppColors.textGrey,
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(height: 14.h),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${wishlistMovies.length}",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 34.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  Text(
                                    "Wish List",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${historyMovies.length}",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 34.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  Text(
                                    "History",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 22.sp,
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
                                  backgroundColor: AppColors.gold,
                                  textColor: AppColors.background,
                                  onPressed: () async {
                                    final updated = await Navigator.pushNamed(
                                      context,
                                      RouteName.updateProfileScreen,
                                      arguments: {
                                        'name': name,
                                        'avatar': avatar,
                                        'phone': phone,
                                      },
                                    );
                                    if (updated == true && context.mounted) {
                                      context
                                          .read<ProfileCubit>()
                                          .getProfileData();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 16.w),
                              ProfileButton(
                                text: "Exit",
                                backgroundColor: AppColors.btnBgColor,
                                textColor: AppColors.white,
                                icon: Icons.logout,
                                onPressed: () => _showSignOutDialog(context),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                  SliverAppBar(
                    backgroundColor: AppColors.cardBackground,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    toolbarHeight: 0,
                    pinned: true,
                    primary: false,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(88.h),
                      child: Container(
                        color: AppColors.cardBackground,
                        child: TabBar(
                          indicatorColor: AppColors.gold,
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
                    watchlistMovies.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  AppAssets.entertainment,
                                  width: 150.w,
                                  height: 150.h,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "No movies in your watch list yet",
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            itemCount: watchlistMovies.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 122 / 180,
                                ),
                            itemBuilder: (context, index) {
                              final movie = watchlistMovies[index];
                              return MovieCard(
                                imagePath: movie['image'] ?? '',
                                rating: movie['rating'] ?? "0.0",
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    RouteName.movieDatailsScreen,
                                    arguments: {
                                      'id':
                                          int.tryParse(movie['id'] ?? '0') ?? 0,
                                      'title': movie['title'] ?? '',
                                      'image': movie['image'] ?? '',
                                      'rating':
                                          double.tryParse(
                                            movie['rating'] ?? '0.0',
                                          ) ??
                                          0.0,
                                      'year': movie['year'] ?? '',
                                      'runtime':
                                          int.tryParse(
                                            movie['runtime'] ?? '0',
                                          ) ??
                                          0,
                                      'genres': movie['genres'] ?? '',
                                      'summary': movie['summary'] ?? '',
                                      'backgroundImage':
                                          movie['backgroundImage'] ?? '',
                                    },
                                  );
                                  if (context.mounted) {
                                    context
                                        .read<ProfileCubit>()
                                        .getProfileData();
                                  }
                                },
                              );
                            },
                          ),
                    historyMovies.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  AppAssets.entertainment,
                                  width: 150.w,
                                  height: 150.h,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "No watch history yet",
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            itemCount: historyMovies.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 122 / 180,
                                ),
                            itemBuilder: (context, index) {
                              final movie = historyMovies[index];
                              return MovieCard(
                                imagePath: movie['image'] ?? '',
                                rating: movie['rating'] ?? "0.0",
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    RouteName.movieDatailsScreen,
                                    arguments: {
                                      'id':
                                          int.tryParse(movie['id'] ?? '0') ?? 0,
                                      'title': movie['title'] ?? '',
                                      'image': movie['image'] ?? '',
                                      'rating':
                                          double.tryParse(
                                            movie['rating'] ?? '0.0',
                                          ) ??
                                          0.0,
                                      'year': movie['year'] ?? '',
                                      'runtime':
                                          int.tryParse(
                                            movie['runtime'] ?? '0',
                                          ) ??
                                          0,
                                      'genres': movie['genres'] ?? '',
                                      'summary': movie['summary'] ?? '',
                                      'backgroundImage':
                                          movie['backgroundImage'] ?? '',
                                    },
                                  );
                                  if (context.mounted) {
                                    context
                                        .read<ProfileCubit>()
                                        .getProfileData();
                                  }
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
