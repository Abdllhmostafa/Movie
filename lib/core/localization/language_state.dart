import 'package:flutter/material.dart';

class LanguageState {
  final Locale locale;

  const LanguageState({required this.locale});

  bool get isEnglish => locale.languageCode == 'en';
  bool get isArabic => locale.languageCode == 'ar';
}
