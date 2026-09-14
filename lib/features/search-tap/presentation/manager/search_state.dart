import 'package:movie_app/features/search-tap/demain/entity/search_entity.dart';

abstract class SearchState<T> {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessState extends SearchState {
  final List<SearchEntity> movies;
  SearchSuccessState(this.movies);
}

class SearchErrorState extends SearchState {
  String errorMessage;
  SearchErrorState(this.errorMessage);
}
