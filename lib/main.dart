import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/auth/data/data_source/data_source_imp.dart';
import 'package:movie_app/features/auth/data/repo/repo_imp.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/features/auth/presentation/screens/login_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/movie_details.dart';
import 'package:movie_app/features/auth/presentation/screens/search_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authDataSource = AuthDataSourceImp();
    final authRepo = AuthRepoImp(authDataSource);
    final loginUseCase = LoginUseCase(authRepo);
    final registerUseCase = RegisterUseCase(authRepo);

    return BlocProvider(
      create: (context) => AuthCubit(loginUseCase, registerUseCase),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Route Movie App',
        theme: AppTheme.darkTheme,
        home: const SearchTab(),
      ),
    );
  }
}
