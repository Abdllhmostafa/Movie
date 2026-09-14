import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/search-tap/demain/use_case/search_use_case.dart';
import 'package:movie_app/features/search-tap/presentation/manager/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchMoviesUseCase;

  SearchCubit(this.searchMoviesUseCase) : super(SearchInitialState());

  void searchMovies(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(SearchInitialState());
      return;
    }

    emit(SearchLoadingState());

    final result = await searchMoviesUseCase(query: trimmedQuery);
    if (isClosed) return;

    result.fold(
      (failure) => emit(SearchErrorState(failure.message)),
      (movies) => emit(SearchSuccessState(movies)),
    );
  }

  void clearSearch() {
    emit(SearchInitialState());
  }
}
