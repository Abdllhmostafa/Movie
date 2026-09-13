import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_details_extra_entity.dart';
import 'package:movie_app/features/layout/demain/repo/movie_repo.dart';

class GetMovieDetailsExtra {
  final MovieRepo movieRepo;
  GetMovieDetailsExtra(this.movieRepo);

  FutureResult<MovieDetailsExtraEntity> call(int movieId) async {
    return await movieRepo.getMovieDetailsExtra(movieId);
  }
}
