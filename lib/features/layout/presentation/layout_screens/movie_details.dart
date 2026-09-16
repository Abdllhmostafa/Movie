import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/services/translation_service.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/layout/data/data_source/movie_remote_data_source.dart';
import 'package:movie_app/features/layout/data/repo/repo_imp.dart';
import 'package:movie_app/features/layout/data/data_source/user_movies_service.dart';
import 'package:movie_app/features/layout/demain/entitiy/cast_entity.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';
import 'package:movie_app/features/layout/demain/use_case/get_movie_details_extra.dart';
import 'package:movie_app/features/layout/demain/use_case/get_similar_movies.dart';
import 'package:movie_app/features/layout/presentation/widgets/cast_item_card.dart';
import 'package:movie_app/features/layout/presentation/widgets/genre_chip.dart';
import 'package:movie_app/features/layout/presentation/widgets/movie_details_header.dart';
import 'package:movie_app/features/layout/presentation/widgets/movie_poster_card.dart';
import 'package:movie_app/features/layout/presentation/widgets/movie_screenshots_section.dart';
import 'package:movie_app/features/layout/presentation/widgets/movie_stat_badge.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  bool _isWatchlisted = false;
  bool _isWishlisted = false;
  String? _translatedTitle;
  String? _translatedSummary;
  List<MovieEntity> _similarMoviesList = [];
  List<String> _screenshotsList = [];
  List<CastEntity> _castList = [];
  List<String> _genresList = [];
  bool _isLoadingSimilar = true;
  bool _isLoadingExtra = true;
  bool _isInit = true;

  MovieEntity _extractMovie(Object? args) {
    if (args is MovieEntity) {
      return args;
    } else if (args is Map) {
      final id = args['id'] is int
          ? args['id'] as int
          : int.tryParse(args['id']?.toString() ?? '0') ?? 0;
      final title = args['title']?.toString() ?? 'Movie Details';
      final image = args['image']?.toString() ?? '';
      final rating = args['rating'] is num
          ? (args['rating'] as num).toDouble()
          : double.tryParse(args['rating']?.toString() ?? '7.7') ?? 7.7;
      final year = args['year'] is int
          ? args['year'] as int
          : int.tryParse(args['year']?.toString() ?? '0') ?? 0;
      final runtime = args['runtime'] is int
          ? args['runtime'] as int
          : int.tryParse(args['runtime']?.toString() ?? '0') ?? 0;
      final summary = args['summary']?.toString() ?? '';
      List<String> genres = const [];
      if (args['genres'] is List) {
        genres = (args['genres'] as List).map((e) => e.toString()).toList();
      } else if (args['genres'] is String && (args['genres'] as String).isNotEmpty) {
        genres = (args['genres'] as String).split(', ');
      }
      final bg = args['backgroundImage']?.toString() ?? '';

      return MovieEntity(
        id: id,
        title: title,
        image: image,
        rating: rating,
        year: year,
        runtime: runtime,
        summary: summary,
        genres: genres,
        backgroundImage: bg,
      );
    }
    return MovieEntity(
      id: 0,
      title: 'Movie Details',
      image: '',
      rating: 7.7,
      year: 2024,
      runtime: 120,
      summary:
          'Following unexpected multiverse events, heroes unite to protect reality from imminent collapse while discovering hidden strengths within themselves.',
      genres: const ['Action', 'Adventure', 'Fantasy', 'Sci-Fi'],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _fetchMovieDetailsExtra();
      _isInit = false;
    }
  }

  Future<void> _fetchMovieDetailsExtra() async {
    final movie = _extractMovie(ModalRoute.of(context)?.settings.arguments);

    if (context.loc.isArabic) {
      _translatedTitle =
          TranslationService.instance.getCached(movie.title) ?? movie.title;
      _translatedSummary =
          TranslationService.instance.getCached(movie.summary) ?? movie.summary;

      TranslationService.instance.translateToAr(movie.title).then((val) {
        if (mounted && val != _translatedTitle) {
          setState(() => _translatedTitle = val);
        }
      });

      if (movie.summary.isNotEmpty) {
        TranslationService.instance.translateToAr(movie.summary).then((val) {
          if (mounted && val != _translatedSummary) {
            setState(() => _translatedSummary = val);
          }
        });
      }
    }

    UserMoviesService.isWatchlisted(movie.id, title: movie.title).then((isWatch) {
      if (mounted) {
        setState(() {
          _isWatchlisted = isWatch;
        });
      }
    });

    UserMoviesService.isWishlisted(movie.id, title: movie.title).then((isWish) {
      if (mounted) {
        setState(() {
          _isWishlisted = isWish;
        });
      }
    });

    if (movie.id == 0) {
      if (mounted) {
        setState(() {
          _isLoadingSimilar = false;
          _isLoadingExtra = false;
        });
      }
      return;
    }

    final remoteDataSource = MovieRemoteDataSourceImpl();
    final repo = MovieRepoImp(remoteDataSource);
    final getSimilarMoviesUseCase = GetSimilarMovies(repo);
    final getMovieDetailsExtraUseCase = GetMovieDetailsExtra(repo);

    final similarFuture = getSimilarMoviesUseCase(movie.id);
    final extraFuture = getMovieDetailsExtraUseCase(movie.id);

    final similarResult = await similarFuture;
    final extraResult = await extraFuture;

    if (!mounted) return;

    setState(() {
      similarResult.fold(
        (_) {},
        (movies) => _similarMoviesList = movies,
      );
      extraResult.fold(
        (_) {},
        (extra) {
          _screenshotsList = extra.screenshots;
          _castList = extra.cast;
          _genresList = extra.genres;
        },
      );
      _isLoadingSimilar = false;
      _isLoadingExtra = false;
    });
  }

  static const List<String> _screenshots = [
    'assets/images/screenShot_img1.png',
    'assets/images/screenShot_img2.png',
    'assets/images/screenShot_img3.png',
  ];

  static const List<Map<String, String>> _castMembers = [
    {
      'name': 'Hayley Atwell',
      'character': 'Captain Carter',
      'image': 'assets/images/cast_img.png',
    },
    {
      'name': 'Benedict Cumberbatch',
      'character': 'Stephen Strange',
      'image': 'assets/images/cast_img.png',
    },
    {
      'name': 'Elizabeth Olsen',
      'character': 'Wanda Maximoff',
      'image': 'assets/images/cast_img.png',
    },
    {
      'name': 'Xochitl Gomez',
      'character': 'America Chavez',
      'image': 'assets/images/cast_img.png',
    },
  ];

  static const List<String> _genres = [
    'Action',
    'Adventure',
    'Fantasy',
    'Sci-Fi',
  ];

  static const List<Map<String, String>> _similarMovies = [
    {'image': 'assets/images/movie1_img.png', 'rating': '7.7'},
    {'image': 'assets/images/movie2_img.png', 'rating': '7.7'},
    {'image': 'assets/images/movie3_img.png', 'rating': '7.7'},
    {'image': 'assets/images/docStrange_img.png', 'rating': '7.7'},
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final movie = _extractMovie(ModalRoute.of(context)?.settings.arguments);

    final displayImage = movie.backgroundImage.isNotEmpty
        ? movie.backgroundImage
        : movie.image;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          Column(
            children: [
              SizedBox(
                height: height * 0.69,
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: displayImage.isNotEmpty
                          ? Image.network(
                        displayImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: AppColors.background,
                              child: const Center(
                                child: Icon(
                                  Icons.movie_creation_outlined,
                                  color: AppColors.cardBackground,
                                  size: 64,
                                ),
                              ),
                            ),
                      )
                          : Container(
                        color: AppColors.cardBackground,
                        child: const Center(
                          child: Icon(
                            Icons.movie_creation_outlined,
                            color: AppColors.gold,
                            size: 64,
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
          ),

          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    MovieDetailsHeader(
                      title: (context.loc.isArabic && _translatedTitle != null)
                          ? _translatedTitle!
                          : movie.title,
                      year: movie.year > 0 ? movie.year.toString() : '2024',
                      isFavorite: _isWatchlisted,
                      onBack: () => Navigator.of(context).pop(),
                      onFavorite: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final addedMsg = context.tr(
                          'added_to_watchlist',
                          {'title': movie.title},
                        );
                        final removedMsg = context.tr(
                          'removed_from_watchlist',
                          {'title': movie.title},
                        );
                        final isWatch = await UserMoviesService.toggleWatchlist(
                          id: movie.id,
                          title: movie.title,
                          image: movie.image,
                          rating: movie.rating,
                          year: movie.year > 0 ? movie.year.toString() : '',
                          runtime: movie.runtime,
                          genres: movie.genres,
                          summary: movie.summary,
                          backgroundImage: movie.backgroundImage,
                        );
                        if (!mounted) return;
                        setState(() {
                          _isWatchlisted = isWatch;
                        });
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(isWatch ? addedMsg : removedMsg),
                            duration: const Duration(seconds: 2),
                            backgroundColor: isWatch
                                ? AppColors.success
                                : AppColors.cardBackground,
                          ),
                        );
                      },
                      onPlay: () {
                        UserMoviesService.addToHistory(
                          id: movie.id,
                          title: movie.title,
                          image: movie.image,
                          rating: movie.rating,
                          year: movie.year > 0 ? movie.year.toString() : '',
                          runtime: movie.runtime,
                          genres: movie.genres,
                          summary: movie.summary,
                          backgroundImage: movie.backgroundImage,
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.tr('playing_movie', {'title': movie.title}),
                            ),
                            backgroundColor: AppColors.gold,
                          ),
                        );
                      },
                      onWatch: () {
                        UserMoviesService.addToHistory(
                          id: movie.id,
                          title: movie.title,
                          image: movie.image,
                          rating: movie.rating,
                          year: movie.year > 0 ? movie.year.toString() : '',
                          runtime: movie.runtime,
                          genres: movie.genres,
                          summary: movie.summary,
                          backgroundImage: movie.backgroundImage,
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.tr('watching_movie', {'title': movie.title}),
                            ),
                            backgroundColor: AppColors.gold,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MovieStatBadge(
                          icon: _isWishlisted ? Icons.favorite : Icons.favorite_border,
                          iconColor: _isWishlisted ? AppColors.btnBgColor : AppColors.gold,
                          label: '${15 + (_isWishlisted ? 1 : 0)}',
                          onTap: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final addedMsg = context.tr(
                              'added_to_wishlist',
                              {'title': movie.title},
                            );
                            final removedMsg = context.tr(
                              'removed_from_wishlist',
                              {'title': movie.title},
                            );
                            final isWish = await UserMoviesService.toggleWishlist(
                              id: movie.id,
                              title: movie.title,
                              image: movie.image,
                              rating: movie.rating,
                              year: movie.year > 0 ? movie.year.toString() : '',
                              runtime: movie.runtime,
                              genres: movie.genres,
                              summary: movie.summary,
                              backgroundImage: movie.backgroundImage,
                            );
                            if (!mounted) return;
                            setState(() {
                              _isWishlisted = isWish;
                            });
                            messenger.hideCurrentSnackBar();
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(isWish ? addedMsg : removedMsg),
                                duration: const Duration(seconds: 2),
                                backgroundColor: isWish
                                    ? AppColors.success
                                    : AppColors.cardBackground,
                              ),
                            );
                          },
                        ),
                        MovieStatBadge(
                          icon: Icons.timer,
                          label: movie.runtime > 0 ? '${movie.runtime}' : '90',
                        ),
                        MovieStatBadge(
                          icon: Icons.star,
                          label: movie.rating > 0
                              ? movie.rating.toStringAsFixed(1)
                              : '7.7',
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    if (_isLoadingExtra)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child:
                          CircularProgressIndicator(color: AppColors.gold),
                        ),
                      )
                    else
                      MovieScreenshotsSection(
                        screenshotPaths: _screenshotsList.isNotEmpty
                            ? _screenshotsList
                            : _screenshots,
                      ),

                    SizedBox(height: 24.h),

                    Text(
                      context.tr('similar'),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (_isLoadingSimilar)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child:
                          CircularProgressIndicator(color: AppColors.gold),
                        ),
                      )
                    else if (_similarMoviesList.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14.w,
                          mainAxisSpacing: 14.h,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: _similarMoviesList.length,
                        itemBuilder: (context, index) {
                          final similarMovie = _similarMoviesList[index];
                          return MoviePosterCard(
                            imagePath: similarMovie.image,
                            rating: similarMovie.rating > 0
                                ? similarMovie.rating.toStringAsFixed(1)
                                : '7.7',
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                RouteName.movieDatailsScreen,
                                arguments: similarMovie,
                              );
                            },
                          );
                        },
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14.w,
                          mainAxisSpacing: 14.h,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: _similarMovies.length,
                        itemBuilder: (context, index) {
                          final movie = _similarMovies[index];
                          return MoviePosterCard(
                            imagePath: movie['image']!,
                            rating: movie['rating']!,
                          );
                        },
                      ),

                    SizedBox(height: 24.h),

                    Text(
                      context.tr('summary'),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      (context.loc.isArabic &&
                              _translatedSummary != null &&
                              _translatedSummary!.isNotEmpty)
                          ? _translatedSummary!
                          : (movie.summary.isNotEmpty
                              ? movie.summary
                              : context.tr('no_summary_available')),
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15.sp,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    Text(
                      context.tr('cast'),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (_isLoadingExtra)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child:
                          CircularProgressIndicator(color: AppColors.gold),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _castList.isNotEmpty
                            ? _castList.length
                            : _castMembers.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          if (_castList.isNotEmpty) {
                            final cast = _castList[index];
                            return CastItemCard(
                              name: cast.name,
                              character: cast.character,
                              imagePath: cast.image,
                            );
                          }
                          final cast = _castMembers[index];
                          return CastItemCard(
                            name: cast['name']!,
                            character: cast['character']!,
                            imagePath: cast['image']!,
                          );
                        },
                      ),

                    SizedBox(height: 24.h),

                    Text(
                      context.tr('genres'),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: (_genresList.isNotEmpty
                          ? _genresList
                          : (movie.genres.isNotEmpty
                          ? movie.genres
                          : _genres))
                          .map((genre) => GenreChip(label: context.trGenre(genre)))
                          .toList(),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}