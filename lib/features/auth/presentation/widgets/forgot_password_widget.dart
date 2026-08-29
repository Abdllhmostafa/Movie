import 'package:e_commerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ForgotPasswordWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;

  const ForgotPasswordWidget({
    super.key,
    this.onTap,
    this.color = AppColors.textWhite,
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
            'Forgot password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
