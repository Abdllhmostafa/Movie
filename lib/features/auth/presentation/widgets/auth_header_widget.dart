import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final CrossAxisAlignment crossAxisAlignment;

  const AuthHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrey,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
