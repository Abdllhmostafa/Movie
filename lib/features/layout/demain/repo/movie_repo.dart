import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';

abstract class MovieRepo {
  FutureResult<List<MovieEntity>> getAllMovie();
}
