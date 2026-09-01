import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/routes/app_routers.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/auth/data/data_source/data_source_imp.dart';
import 'package:movie_app/features/auth/data/repo/repo_imp.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    final appRouters = AppRouters();
    final authDataSource = AuthDataSourceImp();
    final authRepo = AuthRepoImp(authDataSource);
    final loginUseCase = LoginUseCase(authRepo);
    final registerUseCase = RegisterUseCase(authRepo);

    return BlocProvider(
      create: (context) => AuthCubit(loginUseCase, registerUseCase),
      child: ScreenUtilInit(
        designSize: Size(430,932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            initialRoute: RouteName.splash,
            onGenerateRoute:appRouters.generateRoute ,
            debugShowCheckedModeBanner: false,
            title: 'Route Movie App',
            theme: AppTheme.darkTheme,

          );
        },
      ),
    );
  }
}
