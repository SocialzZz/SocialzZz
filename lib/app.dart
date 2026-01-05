import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/representation/routes/app_router.dart';
import 'package:flutter_social_media_app/representation/routes/route_names.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SocialzZz',

      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
