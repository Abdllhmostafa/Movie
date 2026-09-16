import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/localization/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'app_language';

  LanguageCubit() : super(const LanguageState(locale: Locale('en'))) {
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLangCode = prefs.getString(_languageKey);
      if (savedLangCode != null && (savedLangCode == 'en' || savedLangCode == 'ar')) {
        emit(LanguageState(locale: Locale(savedLangCode)));
      }
    } catch (_) {

    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (state.locale.languageCode == languageCode) return;
    final newLocale = Locale(languageCode);
    emit(LanguageState(locale: newLocale));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (_) {}
  }

  Future<void> toggleLanguage() async {
    final nextCode = state.isEnglish ? 'ar' : 'en';
    await changeLanguage(nextCode);
  }

  Future<void> setEnglish() async {
    await changeLanguage('en');
  }

  Future<void> setArabic() async {
    await changeLanguage('ar');
  }
}
