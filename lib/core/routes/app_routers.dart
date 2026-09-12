import 'package:flutter/material.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/features/auth/presentation/screens/auth_screens/login_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/auth_screens/register_screen.dart';
import 'package:movie_app/features/layout/presentation/layout_screens/movie_details.dart';
import 'package:movie_app/features/layout/presentation/profile/screens/profile_screen.dart';
import 'package:movie_app/features/layout/presentation/profile/screens/update_profile_screen.dart';
import 'package:movie_app/features/layout/presentation/layout_screens/layout_screen.dart';
import 'package:movie_app/features/onboarding/onboarding_screen.dart';
import 'package:movie_app/features/splash/splash_screen.dart';

class AppRouters {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteName.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteName.layout:
        return MaterialPageRoute(builder: (_) => const LayoutScreen());
      case RouteName.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RouteName.updateProfileScreen:
        return MaterialPageRoute(builder: (_) => const UpdateProfileScreen());
      case RouteName.movieDatailsScreen:
        return MaterialPageRoute(builder: (_) => const MovieDetails());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
