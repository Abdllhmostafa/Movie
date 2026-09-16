import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/layout/demain/use_case/get_all_movies.dart';
import 'package:movie_app/features/layout/presentation/layout_screens/home_screen.dart';
import 'package:movie_app/features/layout/presentation/maneger/movie_cubit.dart';
import 'package:movie_app/features/layout/presentation/maneger/movie_state.dart';

class MockMovieCubit extends Cubit<MovieState> implements MovieCubit {
  MockMovieCubit(super.initialState);

  @override
  GetAllMovies get getAllMoviesUseCase => throw UnimplementedError();

  @override
  Future<void> fetchMovies() async {}
}

void main() {
  testWidgets(
    'HomeScreenContent displays loading indicator when state is MovieLoadingState',
    (WidgetTester tester) async {
      final cubit = MockMovieCubit(MovieLoadingState());

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(430, 932),
          builder: (context, child) => MaterialApp(
            home: BlocProvider<MovieCubit>.value(
              value: cubit,
              child: const HomeScreenContent(showBottomNav: false),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'HomeScreenContent displays error message when state is MovieErrorState',
    (WidgetTester tester) async {
      final cubit = MockMovieCubit(MovieErrorState('Failed to load movies'));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(430, 932),
          builder: (context, child) => MaterialApp(
            home: BlocProvider<MovieCubit>.value(
              value: cubit,
              child: const HomeScreenContent(showBottomNav: false),
            ),
          ),
        ),
      );

      expect(find.text('Failed to load movies'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    },
  );

  testWidgets(
    'HomeScreenContent displays empty state when movies list is empty',
    (WidgetTester tester) async {
      final cubit = MockMovieCubit(MovieSuccessState([]));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(430, 932),
          builder: (context, child) => MaterialApp(
            home: BlocProvider<MovieCubit>.value(
              value: cubit,
              child: const HomeScreenContent(showBottomNav: false),
            ),
          ),
        ),
      );

      expect(find.text('No movies available'), findsOneWidget);
    },
  );
}
