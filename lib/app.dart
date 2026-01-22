import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/routes/app_router.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'SocialzZz',

      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
