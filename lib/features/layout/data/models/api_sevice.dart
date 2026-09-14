import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:movie_app/core/network/dio_sevice.dart';
import 'package:movie_app/features/layout/data/models/movie_model.dart';
import 'package:movie_app/features/search-tap/data/models/search_model.dart';
import 'package:movie_app/features/search-tap/demain/entity/search_entity.dart';

class ApiSevice {
  static Future<List<Movies>> getMovies([String? query]) async {
    try {
      final response = await DioSevice.dio.get(
        'list_movies.json',
        queryParameters: query != null && query.isNotEmpty ? {"query_term": query} : null,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : (response.data as Map<String, dynamic>);
        final movieModel = MovieModel.fromJson(data);
        return movieModel.data?.movies ?? [];
      } else {
        throw response.data?["message"] ?? "Failed to fetch movies";
      }
    } on DioException catch (e) {
      throw e.response?.data?["message"] ?? e.message ?? "Something went wrong";
    } catch (e) {
      throw "Something went wrong";
    }
  }

  static Future<List<SearchEntity>> searchMovies(String query) async {
    try {
      final response = await DioSevice.dio.get(
        'list_movies.json',
        queryParameters: {"query_term": query},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : (response.data as Map<String, dynamic>);
        final searchModel = SearchModel.fromJson(data);
        final moviesList = searchModel.data?.searchmovies ?? [];
        return moviesList.map((movie) => movie.toEntity()).toList();
      } else {
        throw response.data?["message"] ?? "Failed to fetch search results";
      }
    } on DioException catch (e) {
      throw e.response?.data?["message"] ?? e.message ?? "Something went wrong";
    } catch (e) {
      throw "Something went wrong";
    }
  }
}
