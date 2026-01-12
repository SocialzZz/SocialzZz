import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/status_data.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';

class StatusCardWidget extends StatelessWidget {
  final StatusData data;

  const StatusCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // 1. Header: Avatar, Name, Verified, More icon
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 6,
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(data.userAvatar),
            ),
            title: Row(
              children: [
                Text(
                  data.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (data.isVerified)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.verified, color: Colors.orange, size: 16),
                  ),
              ],
            ),
            subtitle: Text(
              "@${data.userName.toLowerCase().replaceAll(' ', '_')}",
            ),
            trailing: const Icon(Icons.more_vert),
          ),

          // 2. Nội dung: Hình ảnh bài đăng
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  data.postImage,
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),

          // 3. Footer: Like, Comment, Share, Save
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                _buildInteractionItem(Icons.favorite_border, data.likes),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RouteNames.comment),
                  child: _buildInteractionItem(
                    Icons.chat_outlined,
                    data.comments,
                  ),
                ),
                const SizedBox(width: 15),
                _buildInteractionItem(Icons.reply_rounded, data.shares),
                const Spacer(),
                const Icon(Icons.bookmark_border, size: 28),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              thickness: 1,
              color: Color.fromARGB(255, 207, 205, 205),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionItem(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.black87),
        const SizedBox(width: 4),
        Text(count, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
