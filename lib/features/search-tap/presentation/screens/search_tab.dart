import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/presentation/widgets/bottom_nav_bar.dart';
import 'package:movie_app/features/layout/presentation/widgets/movie_poster_card.dart';
import 'package:movie_app/features/search-tap/data/data_source/search_remote_data_source.dart';
import 'package:movie_app/features/search-tap/data/repo/search_repo_imp.dart';
import 'package:movie_app/features/search-tap/demain/use_case/search_use_case.dart';
import 'package:movie_app/features/search-tap/presentation/manager/search_cubit.dart';
import 'package:movie_app/features/search-tap/presentation/manager/search_state.dart';

class SearchTab extends StatelessWidget {
  final bool showBottomNav;

  const SearchTab({super.key, this.showBottomNav = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        SearchUseCase(SearchRepoImp(SearchRemoteDataSourceImpl())),
      ),
      child: SearchTabContent(showBottomNav: showBottomNav),
    );
  }
}

class SearchTabContent extends StatefulWidget {
  final bool showBottomNav;

  const SearchTabContent({super.key, this.showBottomNav = false});

  @override
  State<SearchTabContent> createState() => _SearchTabContentState();
}

class _SearchTabContentState extends State<SearchTabContent> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.read<SearchCubit>().searchMovies(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.only(top: 32.h, right: 16.w, left: 16.w),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: AppColors.white, fontSize: 16.sp),
              cursorColor: AppColors.gold,
              onChanged: (val) {
                setState(() {});
                _onSearchChanged(val);
              },
              onSubmitted: (val) {
                _debounceTimer?.cancel();
                context.read<SearchCubit>().searchMovies(val);
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.gold,
                  size: 24.sp,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.textGrey,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          _debounceTimer?.cancel();
                          _searchController.clear();
                          setState(() {});
                          context.read<SearchCubit>().clearSearch();
                        },
                      )
                    : null,
                hintText: 'Search movies...',
                hintStyle: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 16.sp,
                ),
                fillColor: AppColors.inputFill,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.gold.withValues(alpha: 0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(color: AppColors.gold),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    );
                  }

                  if (state is SearchErrorState) {
                    return Center(
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
                            onPressed: () => context
                                .read<SearchCubit>()
                                .searchMovies(_searchController.text),
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
                    );
                  }

                  if (state is SearchSuccessState) {
                    if (state.movies.isEmpty) {
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
                              'No movies found',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Try searching with another keyword',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14.w,
                        mainAxisSpacing: 14.h,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return MoviePosterCard(
                          imagePath: movie.image,
                          rating: movie.rating > 0
                              ? movie.rating.toStringAsFixed(1)
                              : '7.7',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.movieDatailsScreen,
                              arguments: movie.toMovieEntity(),
                            );
                          },
                        );
                      },
                    );
                  }

                  // SearchInitialState
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/search_icn.png',
                          width: 140.w,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.search,
                            size: 100.sp,
                            color: AppColors.gold.withValues(alpha: 0.5),
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
      bottomNavigationBar: widget.showBottomNav
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const BottomNavBar(),
              ),
            )
          : null,
    );
  }
}
