import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:movie_app/core/network/dio_sevice.dart';
import 'package:movie_app/features/search-tap/data/models/search_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchMovies>> searchMovies(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  @override
  Future<List<SearchMovies>> searchMovies(String query) async {
    try {
      final response = await DioSevice.dio.get(
        'https://movies-api.accel.li/api/v2/list_movies.json',
        queryParameters: {'query_term': query},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : (response.data as Map<String, dynamic>);
        final searchModel = SearchModel.fromJson(data);
        return searchModel.data?.searchmovies ?? [];
      } else {
        throw Exception('Failed to load search results (${response.statusCode})');
      }
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['status_message']?.toString())
          : null;
      throw Exception(message ?? e.message ?? 'Network Error');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
