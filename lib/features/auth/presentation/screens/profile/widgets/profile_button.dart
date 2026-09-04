import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final VoidCallback? onPressed;

  const ProfileButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: CupertinoButton(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: 10.w),
              Icon(
                icon,
                color: textColor,
                size: 22.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}