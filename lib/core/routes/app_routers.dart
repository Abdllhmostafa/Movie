import 'package:flutter/material.dart';
import 'package:movie_app/core/routes/route_name.dart';
import 'package:movie_app/features/auth/presentation/screens/auth_screens/login_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/auth_screens/register_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/layout/layout_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/profile/screens/profile_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/profile/screens/update_profile_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/splash/splash_screen.dart';

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

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
