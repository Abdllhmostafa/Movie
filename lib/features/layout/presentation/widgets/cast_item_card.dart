import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/app_localizations.dart';
import 'package:movie_app/core/services/translation_service.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class CastItemCard extends StatefulWidget {
  final String name;
  final String character;
  final String imagePath;

  const CastItemCard({
    super.key,
    required this.name,
    required this.character,
    required this.imagePath,
  });

  @override
  State<CastItemCard> createState() => _CastItemCardState();
}

class _CastItemCardState extends State<CastItemCard> {
  String? _translatedName;
  String? _translatedCharacter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTranslations();
  }

  @override
  void didUpdateWidget(covariant CastItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name ||
        oldWidget.character != widget.character) {
      _loadTranslations();
    }
  }

  void _loadTranslations() {
    final isArabic = context.loc.isArabic;
    if (!isArabic) {
      setState(() {
        _translatedName = widget.name;
        _translatedCharacter = widget.character;
      });
      return;
    }

    _translatedName =
        TranslationService.instance.getCached(widget.name) ?? widget.name;
    _translatedCharacter =
        TranslationService.instance.getCached(widget.character) ??
            widget.character;

    TranslationService.instance.translateToAr(widget.name).then((val) {
      if (mounted && val != _translatedName) {
        setState(() => _translatedName = val);
      }
    });

    TranslationService.instance.translateToAr(widget.character).then((val) {
      if (mounted && val != _translatedCharacter) {
        setState(() => _translatedCharacter = val);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _translatedName ?? widget.name;
    final displayCharacter = _translatedCharacter ?? widget.character;

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              height: 60.h,
              width: 60.w,
              child: widget.imagePath.startsWith('http')
                  ? Image.network(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cardBackground,
                        child: Icon(
                          Icons.person,
                          color: AppColors.textGrey,
                          size: 28.sp,
                        ),
                      ),
                    )
                  : Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cardBackground,
                        child: Icon(
                          Icons.person,
                          color: AppColors.textGrey,
                          size: 28.sp,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${context.tr('name_label')} : $displayName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${context.tr('character_label')} : $displayCharacter',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
