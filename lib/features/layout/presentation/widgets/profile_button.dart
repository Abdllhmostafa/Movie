import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;

  const ProfileButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: width ?? double.infinity,
      child: CupertinoButton(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: 8.w),
              Icon(
                icon,
                color: textColor,
                size: 20.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}