import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/search-tap/data/data_source/search_remote_data_source.dart';
import 'package:movie_app/features/search-tap/data/models/search_model.dart';
import 'package:movie_app/features/search-tap/demain/entity/search_entity.dart';
import 'package:movie_app/features/search-tap/demain/repo/search_repo.dart';

class SearchRepoImp implements SearchRepo {
  final SearchRemoteDataSource searchRemoteDataSource;

  SearchRepoImp(this.searchRemoteDataSource);

  @override
  FutureResult<List<SearchEntity>> searchMovies(String query) async {
    try {
      final searchMovies = await searchRemoteDataSource.searchMovies(query);
      final searchEntities = searchMovies.map((e) => e.toEntity()).toList();
      return Right(searchEntities);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      return Left(APIFailure(message, 505));
    }
  }
}
