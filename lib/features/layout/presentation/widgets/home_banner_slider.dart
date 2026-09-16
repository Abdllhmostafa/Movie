import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/localization/language_cubit.dart';
import 'package:movie_app/core/localization/language_state.dart';
import 'package:movie_app/core/theme/app_colors.dart';
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
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final isArabic = langState.isArabic ||
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
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
            SizedBox(height: 8.h),
            CarouselSlider(
              options: CarouselOptions(
                height: 350.h,
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
                : Image.asset(
                    'assets/images/img_watchNow.png',
                    width: 340.w,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
          ],
        );
      },
    );
  }
}
