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
    return Center(child: Image.asset('assets/logos/logo_app.png'));
  }
}

// Alias for semantic movie app naming
typedef MovieLogoWidget = RouteLogoWidget;
