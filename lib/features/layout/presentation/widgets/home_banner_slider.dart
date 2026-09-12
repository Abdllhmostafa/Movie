import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/layout/presentation/widgets/movie_poster_card.dart';

class HomeBannerSlider extends StatelessWidget {
  final List<String> movieImages;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const HomeBannerSlider({
    super.key,
    required this.movieImages,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Image.asset(
          'assets/images/img_availableNow.png',
          width: width * 0.6,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
        SizedBox(height: 8.h),
        CarouselSlider(
          options: CarouselOptions(
            height: height * 0.38,
            initialPage: 0,
            viewportFraction: 0.5,
            enlargeCenterPage: true,
            autoPlay: false,
            disableCenter: true,
            animateToClosest: true,
            onPageChanged: (index, reason) {
              onPageChanged(index);
            },
          ),
          items: movieImages.map((imagePath) {
            return MoviePosterCard(
              imagePath: imagePath,
              rating: '7.7',
            );
          }).toList(),
        ),
        Image.asset(
          'assets/images/img_watchNow.png',
          width: width * 0.8,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
