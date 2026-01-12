import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/notification_item.dart';
import 'avatar_placeholder.dart';
import 'post_preview_placeholder.dart';
import 'request_buttons.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;
  final Color accentColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Function(NotificationItem) onAccept;
  final Function(NotificationItem) onDelete;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.onAccept,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarPlaceholder(
            accent: accentColor,
            imageUrl: notification.userImageUrl,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.username,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.actionText,
                  style: TextStyle(fontSize: 14, color: textSecondaryColor),
                ),
              ],
            ),
          ),
          if (notification.type == NotificationType.request) ...[
            const SizedBox(width: 8),
            RequestButtons(
              accentColor: accentColor,
              onAccept: () => onAccept(notification),
              onDelete: () => onDelete(notification),
            ),
          ] else if (notification.postImageUrl != null ||
              notification.postId != null) ...[
            const SizedBox(width: 8),
            PostPreviewPlaceholder(accent: accentColor),
          ],
        ],
      ),
    );
  }
}
