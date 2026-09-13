import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';
import 'package:movie_app/features/layout/demain/repo/movie_repo.dart';

class GetSimilarMovies {
  final MovieRepo movieRepo;
  GetSimilarMovies(this.movieRepo);

  FutureResult<List<MovieEntity>> call(int movieId) async {
    return await movieRepo.getSimilarMovies(movieId);
  }
}
