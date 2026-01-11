import 'package:flutter/material.dart';

class OnlineUserList extends StatelessWidget {
  final Color primaryColor;
  final List<Map<String, String>> onlineUsers;

  const OnlineUserList({
    super.key,
    required this.primaryColor,
    required this.onlineUsers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: onlineUsers.length,
        itemBuilder: (context, index) {
          final user = onlineUsers[index];
          return Container(
            margin: const EdgeInsets.only(right: 18),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Fix: Dùng withAlpha(127) thay vì withOpacity(0.5)
                        border: Border.all(
                          color: Colors.white.withAlpha(127),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user['avatar']!),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 2.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  user['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
