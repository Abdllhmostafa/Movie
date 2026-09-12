import 'package:dio/dio.dart';
import 'package:movie_app/core/network/dio_sevice.dart';
import 'package:movie_app/features/layout/data/models/movie_model.dart';

class ApiSevice {
  static Future<List<Movies>> getNews(String sourceId) async {
    try {
      var response = await DioSevice.dio.get(
        'everything',
        queryParameters: {"sources": sourceId},
      );

      if (response.statusCode == 200) {
        var data = MovieModel.fromJson(response.data);
        return data.data!.movies ?? [];
      } else {
        throw response.data["message"];
      }
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "Something went wrong";
    } catch (e) {
      throw "Something went wrong";
    }
  }
}
