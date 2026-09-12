import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:movie_app/core/network/dio_sevice.dart';
import 'package:movie_app/features/layout/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<Movies>> getMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  @override
  Future<List<Movies>> getMovies() async {
    try {
      final response = await DioSevice.dio.get(
        'https://movies-api.accel.li/api/v2/list_movies.json',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : (response.data as Map<String, dynamic>);
        final movieModel = MovieModel.fromJson(data);
        return movieModel.data?.movies ?? [];
      } else {
        throw Exception('Failed to load movies (${response.statusCode})');
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