import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';
import '../notification/notification_manager.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 5),
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
            child: ValueListenableBuilder<int>(
              valueListenable: NotificationManager.instance.notificationCount,
              builder: (context, count, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none, size: 28),
                    if (count > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
