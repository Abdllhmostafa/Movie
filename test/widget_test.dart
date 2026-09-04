import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/auth/data/data_source/data_source_imp.dart';
import 'package:movie_app/features/auth/data/repo/repo_imp.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/features/auth/presentation/screens/auth_screens/login_screen.dart';
import 'package:movie_app/main.dart';

void main() {
  testWidgets('Movie App smoke test - verifies MyApp launches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Verifies LoginScreen renders with theme, Sign In, and Google auth', (
    WidgetTester tester,
  ) async {
    final authDataSource = AuthDataSourceImp();
    final authRepo = AuthRepoImp(authDataSource);
    final loginUseCase = LoginUseCase(authRepo);
    final registerUseCase = RegisterUseCase(authRepo);

    await tester.pumpWidget(
      BlocProvider(
        create: (context) => AuthCubit(loginUseCase, registerUseCase),
        child: ScreenUtilInit(
          designSize: const Size(430, 932),
          builder: (context, child) {
            return MaterialApp(
              theme: AppTheme.darkTheme,
              home: const LoginScreen(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Login with Google'), findsOneWidget);
    expect(find.text('OR'), findsOneWidget);
  });
}
