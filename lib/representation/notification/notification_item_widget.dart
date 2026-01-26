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
  final Function(NotificationItem)? onUnfriend;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.onAccept,
    required this.onDelete,
    this.onUnfriend,
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
                  notification.requestStatus == FriendRequestStatus.accepted
                      ? 'is now friend'
                      : notification.actionText,
                  style: TextStyle(fontSize: 14, color: textSecondaryColor),
                ),
              ],
            ),
          ),
          // Show Accept/Delete buttons for PENDING or null status (default is pending)
          if (notification.type == NotificationType.request &&
              (notification.requestStatus == null ||
                  notification.requestStatus ==
                      FriendRequestStatus.pending)) ...[
            const SizedBox(width: 8),
            RequestButtons(
              accentColor: accentColor,
              onAccept: () => onAccept(notification),
              onDelete: () => onDelete(notification),
            ),
          ]
          // Show Unfriend button for ACCEPTED requests
          else if (notification.type == NotificationType.request &&
              notification.requestStatus == FriendRequestStatus.accepted) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onUnfriend?.call(notification),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: accentColor, width: 1.4),
                ),
                child: Text(
                  'Unfriend',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ]
          // Show Unfriend for accepted type notifications
          else if (notification.type == NotificationType.accepted) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onUnfriend?.call(notification),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: accentColor, width: 1.4),
                ),
                child: Text(
                  'Unfriend',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ]
          // Show post preview for other notification types
          else if (notification.postImageUrl != null ||
              notification.postId != null) ...[
            const SizedBox(width: 8),
            PostPreviewPlaceholder(accent: accentColor),
          ],
        ],
      ),
    );
  }
}
