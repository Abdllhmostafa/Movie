import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

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
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<MovieCubit>().fetchMovies(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is MovieSuccessState) {
            final movies = state.movies;

            if (movies.isEmpty) {
              return const Center(
                child: Text(
                  'No movies available',
                  style: TextStyle(color: AppColors.white),
                ),
              );
            }

            final currentMovie =
                movies[currentIndex < movies.length ? currentIndex : 0];

            return Stack(
              children: [
                // Top Backdrop with smooth gradient
                _HomeBackdrop(
                  height: height * 0.69,
                  imageUrl: currentMovie.image,
                ),

                // Foreground Scrollable Content
                SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Banners & Carousel Slider
                        _HomeCarousel(
                          width: width,
                          height: height,
                          movies: movies,
                          initialIndex: currentIndex,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),

                        SizedBox(height: height * 0.03),

                        // Section Header: Action Movies
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: const _HomeSectionHeader(title: 'Action'),
                        ),

                        SizedBox(height: height * 0.01),

                        // Horizontal Movie Posters List
                        _HomeHorizontalMovieList(
                          width: width,
                          height: height * 0.28,
                          movies: movies,
                        ),

                        SizedBox(height: height * 0.02),
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
                padding: EdgeInsets.symmetric(horizontal: width * .02),
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
  final double width;
  final double height;
  final List<MovieEntity> movies;
  final int initialIndex;
  final ValueChanged<int> onPageChanged;

  const _HomeCarousel({
    required this.width,
    required this.height,
    required this.movies,
    required this.initialIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/img_availableNow.png', width: width * .6),
        SizedBox(height: height * 0.01),
        CarouselSlider(
          options: CarouselOptions(
            height: height * 0.38,
            initialPage: initialIndex,
            viewportFraction: 0.5,
            enlargeCenterPage: true,
            autoPlay: false,
            disableCenter: true,
            animateToClosest: true,
            onPageChanged: (index, reason) => onPageChanged(index),
          ),
          items: movies.map((movie) {
            return _MoviePoster(movie: movie);
          }).toList(),
        ),
        Image.asset('assets/images/img_watchNow.png', width: width * .8),
      ],
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
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'See More →',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HomeHorizontalMovieList extends StatelessWidget {
  final double width;
  final double height;
  final List<MovieEntity> movies;

  const _HomeHorizontalMovieList({
    required this.width,
    required this.height,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (context, index) => SizedBox(width: width * 0.03),
        itemBuilder: (context, index) {
          return _MoviePoster(movie: movies[index], width: width * 0.35);
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
        borderRadius: BorderRadius.circular(16),
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
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.background.withValues(alpha: 0.71),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, color: AppColors.gold, size: 14),
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
