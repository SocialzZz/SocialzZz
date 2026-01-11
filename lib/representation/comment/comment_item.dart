import 'package:flutter/material.dart';
import '../../data/models/comment_data.dart';

class CommentItem extends StatelessWidget {
  final CommentData comment;
  final bool isReply;
  final VoidCallback? onLike;
  final VoidCallback? onReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.isReply = false,
    this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSingleComment(),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Column(
              children: comment.replies.map((reply) => CommentItem(comment: reply, isReply: true)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSingleComment() {
    return Padding(
      padding: EdgeInsets.only(bottom: isReply ? 12 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: isReply ? 14 : 18, backgroundImage: NetworkImage(comment.avatar)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(comment.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: isReply ? 13 : 14)),
                  const SizedBox(width: 8),
                  Text(comment.time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ]),
                const SizedBox(height: 4),
                Text(comment.text, style: TextStyle(fontSize: isReply ? 13 : 14, color: Colors.black87)),
                const SizedBox(height: 8),
                Row(children: [
                  GestureDetector(
                    onTap: onLike,
                    child: Row(children: [
                      Icon(comment.isLiked ? Icons.favorite : Icons.favorite_border, size: 16, color: comment.isLiked ? Colors.red : Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('${comment.likes}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ]),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: onReply,
                    child: Text('Reply', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
