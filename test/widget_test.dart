import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/localization/language_cubit.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:movie_app/features/auth/data/repo/repo_imp.dart';
import 'package:movie_app/features/auth/domain/use_case/google_sign_in_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/reset_password_use_case.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/features/auth/presentation/screens/auth_screens/login_screen.dart';
import 'package:movie_app/main.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({required String email}) async {}

  @override
  Future<UserCredential> signInWithGoogle() {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('Movie App smoke test - verifies MyApp launches', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MyApp(authRemoteDataSource: FakeAuthRemoteDataSource()),
      );
      await tester.pump();
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  testWidgets(
    'Verifies LoginScreen renders with theme, Login, and Google auth',
    (WidgetTester tester) async {
      final authDataSource = FakeAuthRemoteDataSource();
      final authRepo = AuthRepoImp(authDataSource);
      final loginUseCase = LoginUseCase(authRepo);
      final registerUseCase = RegisterUseCase(authRepo);
      final resetPasswordUseCase = ResetPasswordUseCase(authRepo);
      final googleSignInUseCase = GoogleSignInUseCase(authRepo);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(
                loginUseCase,
                registerUseCase,
                resetPasswordUseCase: resetPasswordUseCase,
                googleSignInUseCase: googleSignInUseCase,
              ),
            ),
            BlocProvider(
              create: (context) => LanguageCubit(),
            ),
          ],
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
      expect(find.text('Login'), findsWidgets);
      expect(find.text('Login With Google'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
    },
  );
}
