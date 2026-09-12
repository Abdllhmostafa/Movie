import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
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
  bool _isFavorite = false;

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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Poster Backdrop
          Column(
            children: [
              SizedBox(
                height: height * 0.69,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/docStrange_img.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
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
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),

          // Scrollable Content
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Back, Favorite, Play, Title, Year, Watch Button)
                    MovieDetailsHeader(
                      title: 'Doctor Strange in the Multiverse of Madness',
                      year: '2022',
                      isFavorite: _isFavorite,
                      onBack: () => Navigator.of(context).pop(),
                      onFavorite: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Stats Row (Likes, Duration, Rating)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        MovieStatBadge(
                          icon: Icons.favorite,
                          label: '15',
                        ),
                        MovieStatBadge(
                          icon: Icons.timer,
                          label: '90',
                        ),
                        MovieStatBadge(
                          icon: Icons.star,
                          label: '7.6',
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Screenshots Section
                    const MovieScreenshotsSection(
                      screenshotPaths: _screenshots,
                    ),

                    SizedBox(height: 24.h),

                    // Similar Movies Section
                    Text(
                      'Similar',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
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

                    // Summary Section
                    Text(
                      'Summary',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Following the events of Spider-Man No Way Home, Doctor Strange unwittingly casts a forbidden spell that accidentally opens up the multiverse. With help from Wong and Scarlet Witch, Strange confronts various versions of himself as well as teaming up with the young America Chavez while traveling through various realities and working to restore reality as he knows it. Along the way, Strange and his allies realize they must take on a powerful new adversary who seeks to take over the multiverse.—Blazer346',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15.sp,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Cast Section
                    Text(
                      'Cast',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _castMembers.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final cast = _castMembers[index];
                        return CastItemCard(
                          name: cast['name']!,
                          character: cast['character']!,
                          imagePath: cast['image']!,
                        );
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Genres Section
                    Text(
                      'Genres',
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
                      children: _genres
                          .map((genre) => GenreChip(label: genre))
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
