import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMoviesService {
  static String _getUserKey(String prefix) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return (uid != null && uid.isNotEmpty)
        ? '${prefix}_$uid'
        : '${prefix}_guest';
  }

  static Future<List<Map<String, String>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getUserKey('user_history');
      final dataStr = prefs.getString(key);
      if (dataStr != null && dataStr.isNotEmpty) {
        final List dynamicList = jsonDecode(dataStr);
        return dynamicList
            .map((item) => Map<String, String>.from(
                (item as Map).map((k, v) => MapEntry(k.toString(), v.toString()))))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<List<Map<String, String>>> getWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getUserKey('user_wishlist');
      final dataStr = prefs.getString(key);
      if (dataStr != null && dataStr.isNotEmpty) {
        final List dynamicList = jsonDecode(dataStr);
        return dynamicList
            .map((item) => Map<String, String>.from(
                (item as Map).map((k, v) => MapEntry(k.toString(), v.toString()))))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<List<Map<String, String>>> getWatchlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getUserKey('user_watchlist');
      final dataStr = prefs.getString(key);
      if (dataStr != null && dataStr.isNotEmpty) {
        final List dynamicList = jsonDecode(dataStr);
        return dynamicList
            .map((item) => Map<String, String>.from(
                (item as Map).map((k, v) => MapEntry(k.toString(), v.toString()))))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<void> addToHistory({
    required int id,
    required String title,
    required String image,
    required double rating,
    String year = '',
    int runtime = 0,
    List<String> genres = const [],
    String summary = '',
    String backgroundImage = '',
    String largeImage = '',
  }) async {
    if (image.isEmpty && title.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getUserKey('user_history');
      final currentList = await getHistory();

      currentList.removeWhere((item) =>
          (id != 0 && item['id'] == id.toString()) ||
          (title.isNotEmpty && item['title'] == title));

      currentList.insert(0, {
        'id': id.toString(),
        'title': title,
        'image': image,
        'rating': rating.toStringAsFixed(1),
        if (year.isNotEmpty) 'year': year,
        if (runtime > 0) 'runtime': runtime.toString(),
        if (genres.isNotEmpty) 'genres': genres.join(', '),
        if (summary.isNotEmpty) 'summary': summary,
        if (backgroundImage.isNotEmpty) 'backgroundImage': backgroundImage,
        if (largeImage.isNotEmpty) 'largeImage': largeImage,
      });

      if (currentList.length > 50) {
        currentList.removeRange(50, currentList.length);
      }

      await prefs.setString(key, jsonEncode(currentList));
    } catch (_) {}
  }

  static Future<bool> toggleWishlist({
    required int id,
    required String title,
    required String image,
    required double rating,
    String year = '',
    int runtime = 0,
    List<String> genres = const [],
    String summary = '',
    String backgroundImage = '',
    String largeImage = '',
  }) async {
    if (image.isEmpty && title.isEmpty) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getUserKey('user_wishlist');
      final currentList = await getWishlist();

      final index = currentList.indexWhere((item) =>
          (id != 0 && item['id'] == id.toString()) ||
          (title.isNotEmpty && item['title'] == title));

      bool isAdded = false;
      if (index >= 0) {
        currentList.removeAt(index);
        isAdded = false;
      } else {
        currentList.insert(0, {
          'id': id.toString(),
          'title': title,
          'image': image,
          'rating': rating.toStringAsFixed(1),
          if (year.isNotEmpty) 'year': year,
          if (runtime > 0) 'runtime': runtime.toString(),
          if (genres.isNotEmpty) 'genres': genres.join(', '),
          if (summary.isNotEmpty) 'summary': summary,
          if (backgroundImage.isNotEmpty) 'backgroundImage': backgroundImage,
          if (largeImage.isNotEmpty) 'largeImage': largeImage,
        });
        isAdded = true;
      }

      await prefs.setString(key, jsonEncode(currentList));
      return isAdded;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> toggleWatchlist({
    required int id,
    required String title,
    required String image,
    required double rating,
    String year = '',
    int runtime = 0,
    List<String> genres = const [],
    String summary = '',
    String backgroundImage = '',
    String largeImage = '',
  }) async {
    if (image.isEmpty && title.isEmpty) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getUserKey('user_watchlist');
      final currentList = await getWatchlist();

      final index = currentList.indexWhere((item) =>
          (id != 0 && item['id'] == id.toString()) ||
          (title.isNotEmpty && item['title'] == title));

      bool isAdded = false;
      if (index >= 0) {
        currentList.removeAt(index);
        isAdded = false;
      } else {
        currentList.insert(0, {
          'id': id.toString(),
          'title': title,
          'image': image,
          'rating': rating.toStringAsFixed(1),
          if (year.isNotEmpty) 'year': year,
          if (runtime > 0) 'runtime': runtime.toString(),
          if (genres.isNotEmpty) 'genres': genres.join(', '),
          if (summary.isNotEmpty) 'summary': summary,
          if (backgroundImage.isNotEmpty) 'backgroundImage': backgroundImage,
          if (largeImage.isNotEmpty) 'largeImage': largeImage,
        });
        isAdded = true;
      }

      await prefs.setString(key, jsonEncode(currentList));
      return isAdded;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isWishlisted(int id, {String? title}) async {
    try {
      final currentList = await getWishlist();
      return currentList.any((item) =>
          (id != 0 && item['id'] == id.toString()) ||
          (title != null && title.isNotEmpty && item['title'] == title));
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isWatchlisted(int id, {String? title}) async {
    try {
      final currentList = await getWatchlist();
      return currentList.any((item) =>
          (id != 0 && item['id'] == id.toString()) ||
          (title != null && title.isNotEmpty && item['title'] == title));
    } catch (_) {
      return false;
    }
  }

  static Future<void> clearUserData(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_history_$uid');
      await prefs.remove('user_wishlist_$uid');
      await prefs.remove('user_watchlist_$uid');
    } catch (_) {}
  }
}
