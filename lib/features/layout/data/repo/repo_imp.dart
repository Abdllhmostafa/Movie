import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/layout/data/data_source/movie_remote_data_source.dart';
import 'package:movie_app/features/layout/data/models/movie_model.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';
import 'package:movie_app/features/layout/demain/repo/movie_repo.dart';

class MovieRepoImp implements MovieRepo {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepoImp(this.remoteDataSource);

  @override
  FutureResult<List<MovieEntity>> getAllMovie() async {
    try {
      final moviesModels = await remoteDataSource.getMovies();
      final moviesEntities = moviesModels.map((e) => e.toEntity()).toList();
      return Right(moviesEntities);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      return Left(APIFailure(message, 505));
    }
  }
}
