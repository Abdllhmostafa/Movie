import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/language_cubit.dart';
import 'package:movie_app/core/localization/language_state.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class LanguageSwitchWidget extends StatelessWidget {
  final ValueChanged<bool>? onLanguageChanged;

  const LanguageSwitchWidget({
    super.key,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final isEnglish = state.isEnglish;

        return Center(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: GestureDetector(
              onTap: () {
                final newIsEnglish = !isEnglish;
                context.read<LanguageCubit>().toggleLanguage();
                onLanguageChanged?.call(newIsEnglish);
              },
              child: Container(
                width: 90.w,
                height: 38.h,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: AppColors.gold,
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      alignment: isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        width: 30.h,
                        height: 30.h,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            context.read<LanguageCubit>().setEnglish();
                            onLanguageChanged?.call(true);
                          },
                          child: _buildUsFlag(),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            context.read<LanguageCubit>().setArabic();
                            onLanguageChanged?.call(false);
                          },
                          child: _buildEgFlag(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsFlag() {
    return Container(
      width: 30.h,
      height: 30.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(
        child: ClipOval(
          child: SizedBox(
            width: 24.r,
            height: 24.r,
            child: CustomPaint(
              painter: _UsFlagPainter(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEgFlag() {
    return Container(
      width: 30.h,
      height: 30.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(
        child: ClipOval(
          child: SizedBox(
            width: 24.r,
            height: 24.r,
            child: Column(
              children: [
                Expanded(child: Container(color: const Color(0xFFCE1126))),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        width: 4.r,
                        height: 3.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC09300),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container(color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UsFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double stripeHeight = h / 7;

    for (int i = 0; i < 7; i++) {
      final paint = Paint()
        ..color = i.isEven ? const Color(0xFFB22234) : Colors.white;
      canvas.drawRect(
        Rect.fromLTWH(0, i * stripeHeight, w, stripeHeight),
        paint,
      );
    }

    final cantonPaint = Paint()..color = const Color(0xFF3C3B6E);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w * 0.45, stripeHeight * 4),
      cantonPaint,
    );

    final starPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.15, stripeHeight * 1.2), 1.2, starPaint);
    canvas.drawCircle(Offset(w * 0.30, stripeHeight * 1.2), 1.2, starPaint);
    canvas.drawCircle(Offset(w * 0.22, stripeHeight * 2.2), 1.2, starPaint);
    canvas.drawCircle(Offset(w * 0.15, stripeHeight * 3.0), 1.2, starPaint);
    canvas.drawCircle(Offset(w * 0.30, stripeHeight * 3.0), 1.2, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
