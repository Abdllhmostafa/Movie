import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/layout/demain/repo/movie_repo.dart';

class GetMovieScreenshots {
  final MovieRepo movieRepo;
  GetMovieScreenshots(this.movieRepo);

  FutureResult<List<String>> call(int movieId) async {
    return await movieRepo.getMovieScreenshots(movieId);
  }
}
