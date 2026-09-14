import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/search-tap/demain/entity/search_entity.dart';
import 'package:movie_app/features/search-tap/demain/repo/search_repo.dart';

class SearchUseCase {
  final SearchRepo searchRepo;

  SearchUseCase(this.searchRepo);

  FutureResult<List<SearchEntity>> call({required String query}) async {
    return await searchRepo.searchMovies(query);
  }
}
