import 'package:flutter/material.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/features/auth/presentation/screens/login/login_screen.dart';

import '../../features/auth/presentation/screens/onboarding/onBoarding_screen.dart';
import '../../features/auth/presentation/screens/splash/splash_screen.dart';

class AppRouters {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RouteName.onBoarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
