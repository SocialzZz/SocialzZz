import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/message.dart';
import 'chat_detail_screen.dart';

class MessageItem extends StatelessWidget {
  final Conversation conversation;
  final Color primaryColor;

  const MessageItem({
    super.key,
    required this.conversation,
    required this.primaryColor,
  });

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime);
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              partnerId: conversation.partner.id,
              name: conversation.partner.name ?? 'Unknown',
              avatar: conversation.partner.avatarUrl ?? '',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[200],
              backgroundImage: conversation.partner.avatarUrl != null
                  ? NetworkImage(conversation.partner.avatarUrl!)
                  : null,
              child: conversation.partner.avatarUrl == null
                  ? Text(
                      conversation.partner.name?.substring(0, 1).toUpperCase() ??
                          '?',
                      style: const TextStyle(fontSize: 24),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.partner.name ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    conversation.lastMessage.content,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: conversation.unreadCount > 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(conversation.lastMessage.createdAt),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                const SizedBox(height: 5),
                if (conversation.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      conversation.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
