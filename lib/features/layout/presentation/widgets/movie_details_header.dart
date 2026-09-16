import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/widgets/auth_button_widget.dart';

class MovieDetailsHeader extends StatelessWidget {
  final String title;
  final String year;
  final VoidCallback onBack;
  final VoidCallback? onFavorite;
  final VoidCallback? onPlay;
  final VoidCallback? onWatch;
  final bool isFavorite;

  const MovieDetailsHeader({
    super.key,
    required this.title,
    required this.year,
    required this.onBack,
    this.onFavorite,
    this.onPlay,
    this.onWatch,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back, color: AppColors.white, size: 26.sp),
            ),
            IconButton(
              onPressed: onFavorite,
              icon: Icon(
                isFavorite ? Icons.bookmark : Icons.bookmark_border,
                color: isFavorite ? AppColors.gold : AppColors.white,
                size: 28.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 120.h),

        InkWell(
          onTap: onPlay,
          borderRadius: BorderRadius.circular(width * 0.12),
          child: CircleAvatar(
            radius: width * .12,
            backgroundColor: AppColors.primary,
            child: CircleAvatar(
              radius: width * .105,
              backgroundColor: AppColors.white,
              child: CircleAvatar(
                radius: width * .08,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 42.sp,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),

        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: 8.h),

        Text(
          year,
          style: TextStyle(
            color: AppColors.movieYearColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),

        AuthButtonWidget(
          backgroundColor: AppColors.btnBgColor,
          textColor: AppColors.white,
          text: context.tr('watch'),
          onPressed: onWatch ?? () {},
        ),
      ],
    );
  }
}
