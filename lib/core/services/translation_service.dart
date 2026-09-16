import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  TranslationService._();
  static final TranslationService instance = TranslationService._();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  final Map<String, String> _memoryCache = {

    'Movie Details': 'تفاصيل الفيلم',
    'Following unexpected multiverse events, heroes unite to protect reality from imminent collapse while discovering hidden strengths within themselves.':
        'في أعقاب أحداث غير متوقعة في الأكوان المتعددة، يتحد الأبطال لحماية الواقع من الانهيار الوشيك بينما يكتشفون قواهم الكامنة في داخلهم.',

    'Hayley Atwell': 'هايلي أتويل',
    'Captain Carter': 'كابتن كارتر',
    'Benedict Cumberbatch': 'بنديكت كمبرباتش',
    'Stephen Strange': 'ستيفن سترينج',
    'Elizabeth Olsen': 'إليزابيث أولسن',
    'Wanda Maximoff': 'واندا ماكسيموف',
    'Xochitl Gomez': 'سوتشيتل غوميز',
    'America Chavez': 'أمريكا تشافيز',
    'Doctor Strange in the Multiverse of Madness':
        'دكتور سترينج في الأكوان المتعددة للجنون',
  };

  bool _initialized = false;
  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    if (_initialized) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (_) {}
  }

  String? getCached(String text) {
    if (text.trim().isEmpty) return text;
    final trimmed = text.trim();
    if (_memoryCache.containsKey(trimmed)) {
      return _memoryCache[trimmed];
    }
    if (_prefs != null) {
      final cached = _prefs!.getString('tr_ar_${trimmed.hashCode}');
      if (cached != null && cached.isNotEmpty) {
        _memoryCache[trimmed] = cached;
        return cached;
      }
    }
    return null;
  }

  Future<String> translateToAr(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return text;

    if (RegExp(r'^[\d\s.,:;!?-]+$').hasMatch(trimmed)) {
      return text;
    }

    await _initPrefs();
    final cached = getCached(trimmed);
    if (cached != null) {
      return cached;
    }

    try {
      final encoded = Uri.encodeComponent(trimmed);
      final response = await _dio.get(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=ar&dt=t&q=$encoded',
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }

        if (data is List && data.isNotEmpty && data[0] is List) {
          final segments = data[0] as List;
          final sb = StringBuffer();
          for (final seg in segments) {
            if (seg is List && seg.isNotEmpty && seg[0] != null) {
              sb.write(seg[0].toString());
            }
          }
          final result = sb.toString().trim();
          if (result.isNotEmpty) {
            _memoryCache[trimmed] = result;
            _prefs?.setString('tr_ar_${trimmed.hashCode}', result);
            return result;
          }
        }
      }
    } catch (_) {

    }

    return text;
  }

  static bool isArabicText(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  static final Map<String, String> _arabicToEnglishDict = {

    'اكشن': 'action',
    'أكشن': 'action',
    'مغامرة': 'adventure',
    'مغامرات': 'adventure',
    'انيميشن': 'animation',
    'أنيميشن': 'animation',
    'رسوم متحركة': 'animation',
    'كرتون': 'animation',
    'كوميديا': 'comedy',
    'كوميدي': 'comedy',
    'جريمة': 'crime',
    'وثائقي': 'documentary',
    'دراما': 'drama',
    'عائلي': 'family',
    'فانتازيا': 'fantasy',
    'خيالي': 'fantasy',
    'تاريخي': 'history',
    'رعب': 'horror',
    'موسيقى': 'music',
    'موسيقي': 'musical',
    'غموض': 'mystery',
    'رومانسي': 'romance',
    'رومانسية': 'romance',
    'خيال علمي': 'sci-fi',
    'رياضي': 'sport',
    'إثارة': 'thriller',
    'اثارة': 'thriller',
    'تشويق': 'thriller',
    'حرب': 'war',
    'حربي': 'war',
    'سيرة ذاتية': 'biography',

    'باتمان': 'batman',
    'الرجل الوطواط': 'batman',
    'سبايدرمان': 'spider-man',
    'سبايدر مان': 'spider-man',
    'الرجل العنكبوت': 'spider-man',
    'افنجرز': 'avengers',
    'أفنجرز': 'avengers',
    'افينجرز': 'avengers',
    'أفينجرز': 'avengers',
    'المنتقمون': 'avengers',
    'سوبرمان': 'superman',
    'الرجل الحديدي': 'iron man',
    'ايرون مان': 'iron man',
    'هالك': 'hulk',
    'ثور': 'thor',
    'دكتور سترينج': 'doctor strange',
    'هاري بوتر': 'harry potter',
    'جون ويك': 'john wick',
    'ماتريكس': 'matrix',
    'الماتريكس': 'matrix',
    'تيتانيك': 'titanic',
    'افاتار': 'avatar',
    'أفاتار': 'avatar',
    'المحقق كونان': 'conan',
    'جوكر': 'joker',
    'الجوكر': 'joker',
    'فاست': 'fast',
    'السرعة والغضب': 'fast and furious',
    'ترانسفورمرز': 'transformers',
    'المتحولون': 'transformers',
    'غودزيلا': 'godzilla',
    'جودزيلا': 'godzilla',
    'كونغ': 'kong',
    'كينغ كونغ': 'king kong',
    'ديدبول': 'deadpool',
    'ولفرين': 'wolverine',
    'ستار وورز': 'star wars',
    'حرب النجوم': 'star wars',
    'سيد الخواتم': 'lord of the rings',
    'قراصنة الكاريبي': 'pirates of the caribbean',
    'المهمة المستحيلة': 'mission impossible',
    'توم كروز': 'tom cruise',
    'ليوناردو دي كابريو': 'leonardo dicaprio',
    'كريستوفر نولان': 'christopher nolan',
  };

  Future<String> translateToEn(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return text;

    final lower = trimmed.toLowerCase();
    if (_arabicToEnglishDict.containsKey(lower)) {
      return _arabicToEnglishDict[lower]!;
    }

    if (!isArabicText(trimmed)) {
      return trimmed;
    }

    await _initPrefs();
    if (_prefs != null) {
      final cached = _prefs!.getString('tr_en_${trimmed.hashCode}');
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    }

    try {
      final encoded = Uri.encodeComponent(trimmed);
      final response = await _dio.get(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=en&dt=t&q=$encoded',
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }

        if (data is List && data.isNotEmpty && data[0] is List) {
          final segments = data[0] as List;
          final sb = StringBuffer();
          for (final seg in segments) {
            if (seg is List && seg.isNotEmpty && seg[0] != null) {
              sb.write(seg[0].toString());
            }
          }
          final result = sb.toString().trim();
          if (result.isNotEmpty) {
            _prefs?.setString('tr_en_${trimmed.hashCode}', result);
            return result;
          }
        }
      }
    } catch (_) {}

    return trimmed;
  }

  Future<String> translate(String text, {required bool isArabic}) async {
    if (!isArabic) return text;
    return translateToAr(text);
  }
}
