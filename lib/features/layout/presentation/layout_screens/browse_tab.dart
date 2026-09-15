import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/data/data_source/movie_remote_data_source.dart';
import 'package:movie_app/features/layout/data/repo/repo_imp.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';
import 'package:movie_app/features/layout/demain/use_case/get_all_movies.dart';
import 'package:movie_app/features/layout/presentation/maneger/movie_cubit.dart';
import 'package:movie_app/features/layout/presentation/maneger/movie_state.dart';
import 'package:movie_app/features/layout/presentation/widgets/movie_poster_card.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

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
      child: const BrowseTabContent(),
    );
  }
}

class BrowseTabContent extends StatelessWidget {
  const BrowseTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<MovieCubit, MovieState>(
          builder: (context, state) {
            if (state is MovieLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }

            if (state is MovieErrorState) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 48.sp,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MovieCubit>().fetchMovies();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is MovieSuccessState) {
              final List<MovieEntity> movies = state.movies;

              // Loop through the movie list and get all genres into a Set to remove duplicates
              final Set<String> genresSet = <String>{};
              for (final movie in movies) {
                for (final genre in movie.genres) {
                  final trimmed = genre.trim();
                  if (trimmed.isNotEmpty) {
                    genresSet.add(trimmed);
                  }
                }
              }

              final List<String> genres = genresSet.isNotEmpty
                  ? (genresSet.toList()..sort())
                  : const [
                      'Action',
                      'Adventure',
                      'Animation',
                      'Comedy',
                      'Crime',
                      'Drama',
                      'Horror',
                      'Romance',
                      'Sci-Fi',
                      'Thriller',
                    ];

              return DefaultTabController(
                length: genres.length,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Horizontal TabBar with category tabs from Set
                      SizedBox(
                        height: 42.h,
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          labelPadding: EdgeInsets.only(right: 8.w),
                          indicator: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          dividerColor: Colors.transparent,
                          tabs: genres.map((genre) {
                            return Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 6.h,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(genre),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // TabBarView showing movies filtered for each genre tab
                      Expanded(
                        child: TabBarView(
                          children: genres.map((genre) {
                            final genreMovies = movies.where((movie) {
                              return movie.genres.any((g) =>
                                  g.trim().toLowerCase() ==
                                  genre.toLowerCase());
                            }).toList();

                            if (genreMovies.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.movie_filter_outlined,
                                      color: AppColors.textGrey,
                                      size: 60.sp,
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'No movies found for $genre',
                                      style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                                top: 4.h,
                                bottom: 90.h,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14.w,
                                mainAxisSpacing: 14.h,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: genreMovies.length,
                              itemBuilder: (context, index) {
                                final movie = genreMovies[index];
                                return MoviePosterCard(
                                  imagePath: movie.image,
                                  rating: movie.rating > 0
                                      ? movie.rating.toStringAsFixed(1)
                                      : '7.7',
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteName.movieDatailsScreen,
                                      arguments: movie,
                                    );
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
