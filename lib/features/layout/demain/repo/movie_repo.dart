import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_details_extra_entity.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';

abstract class MovieRepo {
  FutureResult<List<MovieEntity>> getAllMovie();
  FutureResult<List<MovieEntity>> getSimilarMovies(int movieId);
  FutureResult<List<String>> getMovieScreenshots(int movieId);
  FutureResult<MovieDetailsExtraEntity> getMovieDetailsExtra(int movieId);
}
