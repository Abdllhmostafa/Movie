import 'package:movie_app/core/utils/type_def.dart';
import 'package:movie_app/features/search-tap/demain/entity/search_entity.dart';

abstract class SearchRepo {
  FutureResult<List<SearchEntity>> searchMovies(String query);
}
