import 'package:flutter/material.dart';
import 'package:movie_app/core/localization/ar.dart';
import 'package:movie_app/core/localization/en.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations != null) {
      return localizations;
    }
    final locale = Localizations.maybeLocaleOf(context) ?? const Locale('en');
    return AppLocalizations(locale);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  bool get isArabic => locale.languageCode == 'ar';
  bool get isEnglish => locale.languageCode == 'en';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': enTranslations,
    'ar': arTranslations,
  };

  static final Map<String, String> _arabicGenres = arGenres;

  String translate(String key, [Map<String, String>? args]) {
    final languageCode = locale.languageCode;
    String text = _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
    if (args != null) {
      args.forEach((placeholder, value) {
        text = text.replaceAll('{$placeholder}', value);
      });
    }
    return text;
  }

  String translateGenre(String genre) {
    if (!isArabic) return genre;
    final normalized = genre.trim().toLowerCase();
    return _arabicGenres[normalized] ?? genre;
  }

  String translateError(String rawError) {
    if (!isArabic) {
      return rawError;
    }

    final lower = rawError.toLowerCase();

    if (lower.contains('requires-recent-login') ||
        lower.contains('recent-login') ||
        lower.contains('credential_too_old')) {
      return 'هذا الإجراء يتطلب إعادة تسجيل الدخول لأسباب أمنية. يرجى تسجيل الخروج ثم الدخول مجدداً.';
    }

    if (lower.contains('user-not-found') ||
        lower.contains('no user found')) {
      return 'لا يوجد حساب مسجل بهذا البريد الإلكتروني.';
    }

    if (lower.contains('wrong-password') ||
        lower.contains('invalid-credential') ||
        lower.contains('invalid email or password') ||
        lower.contains('invalid credentials')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
    }

    if (lower.contains('email-already-in-use') ||
        lower.contains('already in use') ||
        lower.contains('already exists')) {
      return 'يوجد حساب مسجل بالفعل بهذا البريد الإلكتروني.';
    }

    if (lower.contains('invalid-email') ||
        lower.contains('not valid') ||
        lower.contains('is invalid')) {
      return 'البريد الإلكتروني المدخل غير صالح.';
    }

    if (lower.contains('weak-password') ||
        lower.contains('too weak')) {
      return 'كلمة المرور المدخلة ضعيفة جداً.';
    }

    if (lower.contains('network') ||
        lower.contains('socket') ||
        lower.contains('connection') ||
        lower.contains('network-request-failed')) {
      return 'خطأ في الاتصال بالإنترنت. يرجى التحقق من اتصالك بالشبكة.';
    }

    if (lower.contains('too-many-requests') ||
        lower.contains('too many attempts')) {
      return 'محاولات كثيرة خاطئة. يرجى المحاولة مرة أخرى لاحقاً.';
    }

    if (lower.contains('error_aborted_by_user') ||
        lower.contains('aborted by user') ||
        lower.contains('cancelled')) {
      return 'تم إلغاء تسجيل الدخول بجوجل.';
    }

    if (lower.contains('no email associated')) {
      return 'لا يوجد بريد إلكتروني مسجل لهذا الحساب.';
    }

    if (lower.contains('passwords do not match')) {
      return 'كلمتا المرور غير متطابقتين.';
    }

    if (lower.contains('name cannot be empty')) {
      return 'لا يمكن ترك الاسم فارغاً.';
    }

    if (lower.contains('user data not found')) {
      return 'لم يتم العثور على بيانات المستخدم.';
    }

    if (lower.contains('timeout') || lower.contains('timed out')) {
      return 'انتهت مهلة الطلب. يرجى إعادة المحاولة.';
    }

    return 'حدث خطأ. يرجى إعادة المحاولة.';
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
  String tr(String key, [Map<String, String>? args]) =>
      AppLocalizations.of(this).translate(key, args);
  String trGenre(String genre) => AppLocalizations.of(this).translateGenre(genre);
  String trError(String error) => AppLocalizations.of(this).translateError(error);
}
