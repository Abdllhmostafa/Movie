import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class MovieScreenshotsSection extends StatelessWidget {
  final List<String> screenshotPaths;

  const MovieScreenshotsSection({
    super.key,
    required this.screenshotPaths,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('screenshots'),
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ...screenshotPaths.map(
          (path) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: path.startsWith('http')
                  ? Image.network(
                      path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140.h,
                        width: double.infinity,
                        color: AppColors.surface,
                        child: Icon(Icons.image,
                            color: AppColors.textGrey, size: 36.sp),
                      ),
                    )
                  : Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140.h,
                        width: double.infinity,
                        color: AppColors.surface,
                        child: Icon(Icons.image,
                            color: AppColors.textGrey, size: 36.sp),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
