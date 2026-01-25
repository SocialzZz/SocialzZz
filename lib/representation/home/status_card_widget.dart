// lib/representation/home/status_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/post_model.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';

class StatusCardWidget extends StatelessWidget {
  final PostModel post; // ⭐ THAY ĐỔI: Nhận PostModel thay vì StatusData

  const StatusCardWidget({super.key, required this.post});

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
              backgroundImage: _getImageProvider(post.userAvatar),
              backgroundColor: Colors.grey[200],
            ),
            title: Row(
              children: [
                Text(
                  post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (post.isVerified)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.verified, color: Colors.orange, size: 16),
                  ),
              ],
            ),
            subtitle: Text(
              "@${post.userName.toLowerCase().replaceAll(' ', '_')}",
            ),
            trailing: const Icon(Icons.more_vert),
          ),

          // 2. Nội dung text (nếu có)
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  post.content,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          // 3. Hình ảnh bài đăng
          if (post.postImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _buildPostImage(post.postImage),
            ),

          // 4. Footer: Like, Comment, Share, Save
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                _buildInteractionItem(Icons.favorite_border, post.likes),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context, 
                      RouteNames.comment,
                      arguments: {
                        'postId': post.id, // ID bài viết (Bắt buộc để API gọi đúng)
                        'postOwnerAvatar': post.userAvatar,
                        'postCaption': post.content,
                      },
                    );
                  },
                  child: _buildInteractionItem(
                    Icons.chat_outlined,
                    post.comments,
                  ),
                ),
                const SizedBox(width: 15),
                _buildInteractionItem(Icons.reply_rounded, post.shares),
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

  // Helper: Xử lý cả asset và network image
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(imageUrl);
    }
  }

  // Helper: Build post image với loading và error handling
  Widget _buildPostImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 350,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 350,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFFF9622E),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/i.jpg',
            width: double.infinity,
            height: 350,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: 350,
        fit: BoxFit.cover,
      );
    }
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
