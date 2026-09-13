import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:movie_app/core/network/dio_sevice.dart';
import 'package:movie_app/features/layout/data/models/movie_model.dart';
import 'package:movie_app/features/layout/demain/entitiy/cast_entity.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_details_extra_entity.dart';

abstract class MovieRemoteDataSource {
  Future<List<Movies>> getMovies();
  Future<List<Movies>> getSimilarMovies(int movieId);
  Future<List<String>> getMovieScreenshots(int movieId);
  Future<MovieDetailsExtraEntity> getMovieDetailsExtra(int movieId);
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

  @override
  Future<List<Movies>> getSimilarMovies(int movieId) async {
    try {
      final response = await DioSevice.dio.get(
        'https://movies-api.accel.li/api/v2/movie_suggestions.json?movie_id=$movieId',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : (response.data as Map<String, dynamic>);
        final movieModel = MovieModel.fromJson(data);
        return movieModel.data?.movies ?? [];
      } else {
        throw Exception(
          'Failed to load similar movies (${response.statusCode})',
        );
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

  @override
  Future<List<String>> getMovieScreenshots(int movieId) async {
    final extra = await getMovieDetailsExtra(movieId);
    return extra.screenshots;
  }

  @override
  Future<MovieDetailsExtraEntity> getMovieDetailsExtra(int movieId) async {
    try {
      final response = await DioSevice.dio.get(
        'https://movies-api.accel.li/api/v2/movie_details.json?movie_id=$movieId&with_images=true&with_cast=true',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : (response.data as Map<String, dynamic>);
        final movie = data['data']?['movie'] as Map<String, dynamic>?;
        if (movie == null) return const MovieDetailsExtraEntity();

        // Screenshots
        final List<String> screenshots = [];
        for (int i = 1; i <= 3; i++) {
          final shot = movie['large_screenshot_image$i']?.toString() ??
              movie['medium_screenshot_image$i']?.toString();
          if (shot != null && shot.isNotEmpty) {
            screenshots.add(shot);
          }
        }

        // Cast
        final List<CastEntity> castList = [];
        if (movie['cast'] != null && movie['cast'] is List) {
          for (final c in movie['cast']) {
            if (c is Map<String, dynamic>) {
              castList.add(
                CastEntity(
                  name: c['name']?.toString() ?? '',
                  character: c['character_name']?.toString() ?? '',
                  image: c['url_small_image']?.toString() ?? '',
                ),
              );
            }
          }
        }

        // Genres
        final List<String> genresList = [];
        if (movie['genres'] != null && movie['genres'] is List) {
          for (final g in movie['genres']) {
            if (g != null && g.toString().isNotEmpty) {
              genresList.add(g.toString());
            }
          }
        }

        return MovieDetailsExtraEntity(
          screenshots: screenshots,
          cast: castList,
          genres: genresList,
        );
      }
      return const MovieDetailsExtraEntity();
    } catch (_) {
      return const MovieDetailsExtraEntity();
    }
  }
}