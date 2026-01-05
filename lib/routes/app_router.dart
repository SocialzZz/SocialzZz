import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/representation/home/home_screen.dart';
import 'package:flutter_social_media_app/representation/welcome/welcome.dart';

import '../representation/splash/splash_screen.dart';
import '../representation/auth/login_screen.dart';
import '../representation/auth/register_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.welcome:
        return MaterialPageRoute(builder: (_) => const Welcome());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
