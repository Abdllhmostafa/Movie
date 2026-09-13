import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/layout/data/data_source/movie_remote_data_source.dart';
import 'package:movie_app/features/layout/data/models/movie_model.dart';
import 'package:movie_app/features/layout/demain/entitiy/movie_details_extra_entity.dart';
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

  @override
  FutureResult<List<MovieEntity>> getSimilarMovies(int movieId) async {
    try {
      final moviesModels = await remoteDataSource.getSimilarMovies(movieId);
      final moviesEntities = moviesModels.map((e) => e.toEntity()).toList();
      return Right(moviesEntities);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      return Left(APIFailure(message, 505));
    }
  }

  @override
  FutureResult<List<String>> getMovieScreenshots(int movieId) async {
    try {
      final screenshots = await remoteDataSource.getMovieScreenshots(movieId);
      return Right(screenshots);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      return Left(APIFailure(message, 505));
    }
  }

  @override
  FutureResult<MovieDetailsExtraEntity> getMovieDetailsExtra(int movieId) async {
    try {
      final extra = await remoteDataSource.getMovieDetailsExtra(movieId);
      return Right(extra);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      return Left(APIFailure(message, 505));
    }
  }
}
