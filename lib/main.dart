import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/routes/app_routers.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:movie_app/features/auth/data/repo/repo_imp.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRemoteDataSource? authRemoteDataSource;

  const MyApp({super.key, this.authRemoteDataSource});

  @override
  Widget build(BuildContext context) {
    final appRouters = AppRouters();
    final dataSource = authRemoteDataSource ?? AuthRemoteDataSourceImp();
    final authRepo = AuthRepoImp(dataSource);
    final loginUseCase = LoginUseCase(authRepo);
    final registerUseCase = RegisterUseCase(authRepo);

    return BlocProvider(
      create: (context) => AuthCubit(loginUseCase, registerUseCase),
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            initialRoute: RouteName.layout,
            onGenerateRoute: appRouters.generateRoute,
            debugShowCheckedModeBanner: false,
            title: 'Route Movie App',
            theme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}
