import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/notification_item.dart';
import 'notification_item_widget.dart';

class NotificationListWidget extends StatelessWidget {
  final List<NotificationItem> notifications;
  final Color accentColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Function(NotificationItem) onAcceptRequest;
  final Function(NotificationItem) onDeleteRequest;
  final Function(NotificationItem)? onUnfriend;  // ← Thêm

  const NotificationListWidget({
    super.key,
    required this.notifications,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.onAcceptRequest,
    required this.onDeleteRequest,
    this.onUnfriend,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          'No notifications',
          style: TextStyle(color: Color(0xFF757575)),
        ),
      );
    }

    final groupedNotifications = <String, List<NotificationItem>>{};
    for (final notification in notifications) {
      final dateLabel = notification.dateLabel;
      if (!groupedNotifications.containsKey(dateLabel)) {
        groupedNotifications[dateLabel] = [];
      }
      groupedNotifications[dateLabel]!.add(notification);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final dateLabel = groupedNotifications.keys.elementAt(index);
        final notificationsByDate = groupedNotifications[dateLabel]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                dateLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textSecondaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...notificationsByDate.map(
              (notification) => NotificationItemWidget(
                notification: notification,
                accentColor: accentColor,
                textPrimaryColor: textPrimaryColor,
                textSecondaryColor: textSecondaryColor,
                onAccept: onAcceptRequest,
                onDelete: onDeleteRequest,
                onUnfriend: onUnfriend,  // ← Truyền down
              ),
            ),
          ],
        );
      },
    );
  }
}