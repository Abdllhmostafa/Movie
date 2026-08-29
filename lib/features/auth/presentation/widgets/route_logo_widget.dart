import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class RouteLogoWidget extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final Color primaryColor;
  final Color secondaryColor;
  final bool showSubtitle;

  const RouteLogoWidget({
    super.key,
    this.iconSize = 64,
    this.fontSize = 32,
    this.primaryColor = AppColors.gold,
    this.secondaryColor = AppColors.textWhite,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cinematic Icon / Clapperboard
        Container(
          width: iconSize + 16,
          height: iconSize + 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.movie_filter_rounded,
              size: iconSize * 0.7,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // App Title
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'ROUTE ',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                  letterSpacing: 3,
                ),
              ),
              TextSpan(
                text: 'MOVIES',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: secondaryColor,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 6),
          Text(
            'WATCH UNLIMITED MOVIES & SHOWS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize * 0.32,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
              letterSpacing: 3,
            ),
          ),
        ],
      ],
    );
  }
}

// Alias for semantic movie app naming
typedef MovieLogoWidget = RouteLogoWidget;
