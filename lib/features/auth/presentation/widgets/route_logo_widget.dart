import 'package:e_commerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RouteLogoWidget extends StatelessWidget {
  final double fontSize;
  final Color color;
  final bool showSubtitle;

  const RouteLogoWidget({
    super.key,
    this.fontSize = 40,
    this.color = AppColors.white,
    this.showSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ROUTE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 4,
            height: 1.1,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 4),
          Text(
            'E-COMMERCE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize * 0.3,
              fontWeight: FontWeight.w400,
              color: color.withValues(alpha: 0.8),
              letterSpacing: 6,
            ),
          ),
        ],
      ],
    );
  }
}
