import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/localization/language_cubit.dart';
import 'package:movie_app/core/localization/language_state.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/data/data_source/movie_remote_data_source.dart';
import 'package:movie_app/features/layout/data/repo/repo_imp.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';
import 'package:movie_app/features/layout/demain/use_case/get_all_movies.dart';
import 'package:movie_app/features/layout/presentation/maneger/movie_cubit.dart';
import 'package:movie_app/features/layout/presentation/maneger/movie_state.dart';
import 'package:movie_app/features/layout/presentation/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  final bool showBottomNav;
  const HomeScreen({super.key, this.showBottomNav = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final remoteDataSource = MovieRemoteDataSourceImpl();
        final repo = MovieRepoImp(remoteDataSource);
        final getAllMoviesUseCase = GetAllMovies(repo);
        return MovieCubit(getAllMoviesUseCase: getAllMoviesUseCase)
          ..fetchMovies();
      },
      child: HomeScreenContent(showBottomNav: showBottomNav),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  final bool showBottomNav;
  const HomeScreenContent({super.key, required this.showBottomNav});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          } else if (state is MovieErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.white),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () => context.read<MovieCubit>().fetchMovies(),
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          } else if (state is MovieSuccessState) {
            final movies = state.movies;

            if (movies.isEmpty) {
              return Center(
                child: Text(
                  context.tr('no_movies_available'),
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }

            final currentMovie =
                movies[currentIndex < movies.length ? currentIndex : 0];

            return Stack(
              children: [
                _HomeBackdrop(height: 640.h, imageUrl: currentMovie.image),

                SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HomeCarousel(
                          movies: movies,
                          initialIndex: currentIndex,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),

                        SizedBox(height: 20.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: _HomeSectionHeader(
                            title: context.tr('action'),
                          ),
                        ),

                        SizedBox(height: 10.h),

                        _HomeHorizontalMovieList(movies: movies),

                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: widget.showBottomNav
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: const BottomNavBar(),
              ),
            )
          : null,
    );
  }
}

class _HomeBackdrop extends StatelessWidget {
  final double height;
  final String imageUrl;

  const _HomeBackdrop({required this.height, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.background,
                    child: const Center(
                      child: Icon(
                        Icons.movie_creation_outlined,
                        color: AppColors.cardBackground,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.8),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _HomeCarousel extends StatelessWidget {
  final List<MovieEntity> movies;
  final int initialIndex;
  final ValueChanged<int> onPageChanged;

  const _HomeCarousel({
    required this.movies,
    required this.initialIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final isArabic =
            langState.isArabic ||
            Localizations.maybeLocaleOf(context)?.languageCode == 'ar' ||
            context.loc.isArabic;

        return Column(
          children: [
            isArabic
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      context.tr('available_now'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.95),
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                          ),
                          Shadow(
                            color: Colors.white.withValues(alpha: 0.35),
                            offset: const Offset(0, 0),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/img_availableNow.png',
                    width: 250.w,
                  ),
            SizedBox(height: 10.h),
            CarouselSlider(
              options: CarouselOptions(
                height: 350.h,
                initialPage: initialIndex,
                viewportFraction: 0.5,
                enlargeCenterPage: true,
                autoPlay: true,
                disableCenter: true,
                animateToClosest: true,
                onPageChanged: (index, reason) => onPageChanged(index),
              ),
              items: movies.map((movie) {
                return _MoviePoster(movie: movie);
              }).toList(),
            ),
            SizedBox(height: 10.h),
            isArabic
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      context.tr('watch_now'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.95),
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                          ),
                          Shadow(
                            color: Colors.white.withValues(alpha: 0.35),
                            offset: const Offset(0, 0),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  )
                : Image.asset('assets/images/img_watchNow.png', width: 340.w),
          ],
        );
      },
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  final String title;

  const _HomeSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          context.tr('see_more'),
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HomeHorizontalMovieList extends StatelessWidget {
  final List<MovieEntity> movies;

  const _HomeHorizontalMovieList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          return _MoviePoster(movie: movies[index], width: 145.w);
        },
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final MovieEntity movie;
  final double? width;

  const _MoviePoster({required this.movie, this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.movieDatailsScreen,
          arguments: movie,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: double.infinity,
              child: Image.network(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.background.withValues(alpha: 0.71),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(Icons.star, color: AppColors.gold, size: 14.sp),
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
