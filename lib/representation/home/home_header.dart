import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/images/SocialzZz-Logo.jpg',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 8),
          const Text(
            'SocialzZz',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RouteNames.search),
            child: const Icon(Icons.search_sharp, size: 28),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RouteNames.notification),
            child: const Icon(Icons.notifications_none, size: 28),
          ),
        ],
      ),
    );
  }
}
