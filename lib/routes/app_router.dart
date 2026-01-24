import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/representation/follow/followers_screen.dart';
import 'package:flutter_social_media_app/representation/follow/following_screen.dart';
import 'package:flutter_social_media_app/representation/home/main_screen.dart';
import 'package:flutter_social_media_app/representation/notification/notification_screen.dart';
import 'package:flutter_social_media_app/representation/profile/editprofile_screen.dart';
import 'package:flutter_social_media_app/representation/search/search_screen.dart';
import 'package:flutter_social_media_app/representation/step/step_screen.dart';
import 'package:flutter_social_media_app/representation/video/video_screen.dart';
import 'package:flutter_social_media_app/representation/welcome/welcome.dart';
import 'package:flutter_social_media_app/representation/comment/comment_screen.dart';

import '../representation/splash/splash_screen.dart';
import '../representation/auth/login_screen.dart';
import '../representation/auth/register_screen.dart';
import '../representation/post/screens/create_post_screen.dart';
import '../representation/post/screens/reaction_list_screen.dart';
import '../representation/profile/profile_screen.dart';
import '../representation/setting/setting_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.welcome:
        return MaterialPageRoute(builder: (_) => const Welcome());

      case RouteNames.step:
        return MaterialPageRoute(builder: (_) => const StepScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case RouteNames.video:
        return MaterialPageRoute(builder: (_) => const VideoScreen());

      case RouteNames.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case RouteNames.post:
        return MaterialPageRoute(builder: (_) => const CreatePostScreen());

      case RouteNames.reactionList:
        return MaterialPageRoute(builder: (_) => const ReactionListScreen());

      case RouteNames.profile:
        final String userId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId));

      case RouteNames.followers:
        return MaterialPageRoute(builder: (_) => const FollowersScreen());

      case RouteNames.following:
        return MaterialPageRoute(builder: (_) => const FollowingScreen());

      case RouteNames.editProfile:
        return MaterialPageRoute(builder: (_) => const EditprofileScreen());

      case RouteNames.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      case RouteNames.setting:
        return MaterialPageRoute(builder: (_) => const SettingScreen());

      case RouteNames.comment:
        return MaterialPageRoute(builder: (_) => const CommentScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
