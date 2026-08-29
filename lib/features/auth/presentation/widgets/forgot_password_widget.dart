import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class ForgotPasswordWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;

  const ForgotPasswordWidget({
    super.key,
    this.onTap,
    this.color = AppColors.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
