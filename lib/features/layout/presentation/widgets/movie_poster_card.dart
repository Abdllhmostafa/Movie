import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class MoviePosterCard extends StatelessWidget {
  final String imagePath;
  final String rating;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const MoviePosterCard({
    super.key,
    required this.imagePath,
    required this.rating,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          imagePath.startsWith('http')
              ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.cardBackground,
                    child: Icon(
                      Icons.movie,
                      color: AppColors.textGrey,
                      size: 32.sp,
                    ),
                  ),
                )
              : Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.cardBackground,
                    child: Icon(
                      Icons.movie,
                      color: AppColors.textGrey,
                      size: 32.sp,
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
                    rating,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
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
    );

    if (width != null || height != null) {
      card = SizedBox(
        width: width,
        height: height,
        child: card,
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap ??
          () {
            Navigator.pushNamed(context, RouteName.movieDatailsScreen);
          },
      child: card,
    );
  }
}
