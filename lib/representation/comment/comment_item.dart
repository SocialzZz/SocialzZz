import 'package:flutter/material.dart';
import '../../data/models/comment_model.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.userAvatar),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 12),
          
          // 2. Cột nội dung chính
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên người dùng
                Text(
                  comment.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Nội dung comment (xuống hàng riêng)
                Text(
                  comment.content,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 3. Hàng thao tác: Tim -> Reply -> Thời gian
                Row(
                  children: [
                    // Nút Tim viền xám (Đã đưa về đầu & để gần lại)
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            // Logic hiển thị tim đỏ nếu đã like (nếu có logic isLiked)
                            comment.isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: comment.isLiked ? Colors.red : Colors.grey[500],
                          ),
                          if (comment.likeCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '${comment.likeCount}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500]
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 20), // Khoảng cách giữa Tim và Reply

                    // Nút Reply
                    GestureDetector(
                      onTap: onReply,
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 20), // Khoảng cách giữa Reply và Thời gian

                    // Thời gian
                    Text(
                      comment.timeAgo,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}