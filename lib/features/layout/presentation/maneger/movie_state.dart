import 'package:movie_app/features/layout/demain/entitiy/movie_entity.dart';

abstract class MovieState<T> {}

class MoviesInitialState extends MovieState {}

class MovieLoadingState extends MovieState {}

class MovieSuccessState extends MovieState {
  final List<MovieEntity> movies;
  MovieSuccessState(this.movies);
}

class MovieErrorState extends MovieState {
  String errorMessage;
  MovieErrorState(this.errorMessage);
}
