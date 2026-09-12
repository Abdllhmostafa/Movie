import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/layout/demain/use_case/get_all_movies.dart';
import 'package:movie_app/features/layout/presentation/maneger/movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final GetAllMovies getAllMoviesUseCase;

  MovieCubit({required this.getAllMoviesUseCase}) : super(MoviesInitialState());
  Future<void> fetchMovies() async {
    emit(MovieLoadingState());
    final result = await getAllMoviesUseCase();
    result.fold(
      (failure) => emit(MovieErrorState(failure.message)),
      (movies) => emit(MovieSuccessState(movies)),
    );
  }
}
