import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/routes/app_routers.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:movie_app/features/auth/data/repo/repo_imp.dart';
import 'package:movie_app/features/auth/domain/use_case/google_sign_in_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/reset_password_use_case.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:movie_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRemoteDataSource? authRemoteDataSource;
  final bool? isUserLoggedIn;

  const MyApp({
    super.key,
    this.authRemoteDataSource,
    this.isUserLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    final appRouters = AppRouters();
    final dataSource = authRemoteDataSource ?? AuthRemoteDataSourceImp();
    final authRepo = AuthRepoImp(dataSource);
    final loginUseCase = LoginUseCase(authRepo);
    final registerUseCase = RegisterUseCase(authRepo);
    final resetPasswordUseCase = ResetPasswordUseCase(authRepo);
    final googleSignInUseCase = GoogleSignInUseCase(authRepo);

    return BlocProvider(
      create: (context) => AuthCubit(
        loginUseCase,
        registerUseCase,
        resetPasswordUseCase: resetPasswordUseCase,
        googleSignInUseCase: googleSignInUseCase,
      ),
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          bool loggedIn = isUserLoggedIn ?? false;
          if (isUserLoggedIn == null) {
            try {
              loggedIn = FirebaseAuth.instance.currentUser != null;
            } catch (_) {
              loggedIn = false;
            }
          }

          return MaterialApp(
            initialRoute: loggedIn ? RouteName.layout : RouteName.login,
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
