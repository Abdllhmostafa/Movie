import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/error/failure.dart';
import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/search-tap/data/models/search_model.dart';
import 'package:movie_app/features/search-tap/demain/entity/search_entity.dart';
import 'package:movie_app/features/search-tap/demain/repo/search_repo.dart';
import 'package:movie_app/features/search-tap/demain/use_case/search_use_case.dart';
import 'package:movie_app/features/search-tap/presentation/manager/search_cubit.dart';
import 'package:movie_app/features/search-tap/presentation/manager/search_state.dart';

class MockSearchRepo implements SearchRepo {
  final List<SearchEntity> mockMovies;
  final bool shouldFail;

  MockSearchRepo({this.mockMovies = const [], this.shouldFail = false});

  @override
  FutureResult<List<SearchEntity>> searchMovies(String query) async {
    if (shouldFail) {
      return Left(APIFailure('Search error', 500));
    }
    return Right(mockMovies);
  }
}

void main() {
  group('Search Model & Entity tests', () {
    test('SearchModel parses integer rating and null movies safely', () {
      final json = {
        'status': 'ok',
        'data': {
          'movie_count': 1,
          'movies': [
            {
              'id': 101,
              'title': 'Test Movie',
              'rating': 0, // integer 0
              'genres': ['Action'],
              'medium_cover_image': 'https://example.com/test.jpg',
            }
          ]
        }
      };

      final model = SearchModel.fromJson(json);
      expect(model.status, 'ok');
      expect(model.data?.searchmovies?.length, 1);

      final movie = model.data!.searchmovies!.first;
      expect(movie.rating, 0.0);
      expect(movie.title, 'Test Movie');

      final entity = movie.toEntity();
      expect(entity.id, 101);
      expect(entity.rating, 0.0);

      final movieEntity = entity.toMovieEntity();
      expect(movieEntity.id, 101);
      expect(movieEntity.title, 'Test Movie');
    });

    test('SearchModel handles empty movies list when query has no matches', () {
      final json = {
        'status': 'ok',
        'data': {'movie_count': 0}
      };

      final model = SearchModel.fromJson(json);
      expect(model.data?.movieCount, 0);
      expect(model.data?.searchmovies, isNull);
    });
  });

  group('SearchCubit tests', () {
    test('emits SearchInitialState when query is empty', () async {
      final repo = MockSearchRepo();
      final useCase = SearchUseCase(repo);
      final cubit = SearchCubit(useCase);

      cubit.searchMovies('   ');
      expect(cubit.state, isA<SearchInitialState>());
      await cubit.close();
    });

    test('emits [SearchLoadingState, SearchSuccessState] on successful query', () async {
      final testMovie = SearchEntity(
        id: 1,
        title: 'Inception',
        image: 'https://example.com/inception.jpg',
        rating: 8.8,
      );
      final repo = MockSearchRepo(mockMovies: [testMovie]);
      final useCase = SearchUseCase(repo);
      final cubit = SearchCubit(useCase);

      final states = <SearchState>[];
      cubit.stream.listen(states.add);

      cubit.searchMovies('Inception');

      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0], isA<SearchLoadingState>());
      expect(states[1], isA<SearchSuccessState>());
      final success = states[1] as SearchSuccessState;
      expect(success.movies.length, 1);
      expect(success.movies.first.title, 'Inception');

      await cubit.close();
    });

    test('emits [SearchLoadingState, SearchErrorState] on failed query', () async {
      final repo = MockSearchRepo(shouldFail: true);
      final useCase = SearchUseCase(repo);
      final cubit = SearchCubit(useCase);

      final states = <SearchState>[];
      cubit.stream.listen(states.add);

      cubit.searchMovies('Batman');

      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.length, 2);
      expect(states[0], isA<SearchLoadingState>());
      expect(states[1], isA<SearchErrorState>());

      await cubit.close();
    });
  });
}
