
import 'package:movie_app/core/use_case/use_case.dart';
import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';
import 'package:movie_app/features/layout/demain/repo/movie_repo.dart';

class GetAllMovies implements UseCase {
  MovieRepo movieRepo;
  GetAllMovies(this.movieRepo);

  @override
  FutureResult<List<MovieEntity>> call() async{
    return await movieRepo.getAllMovie();
  }
}
