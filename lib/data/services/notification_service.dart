import '../models/notification_item.dart';

/// Service interface for notification functionality
abstract class NotificationService {
  Future<List<NotificationItem>> getNotifications();
  Future<void> acceptRequest(String notificationId);
  Future<void> deleteRequest(String notificationId);
  Future<int> getPendingRequestsCount();
}

/// Mock implementation
class MockNotificationService implements NotificationService {
  final List<NotificationItem> _notifications = [
    // Today's notifications
    NotificationItem(
      id: 'n1',
      userId: 'u1',
      username: 'carla_choen',
      type: NotificationType.request,
      createdAt: DateTime.now(),
    ),
    NotificationItem(
      id: 'n2',
      userId: 'u2',
      username: 'angel_n',
      type: NotificationType.like,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      postId: 'p1',
    ),
    NotificationItem(
      id: 'n3',
      userId: 'u3',
      username: 'carla_fisher',
      type: NotificationType.mention,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      postId: 'p2',
    ),
    // Yesterday's notifications
    NotificationItem(
      id: 'n4',
      userId: 'u4',
      username: 'annette_fritsch',
      type: NotificationType.mention,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      postId: 'p3',
    ),
    NotificationItem(
      id: 'n5',
      userId: 'u5',
      username: 'katie_ber',
      type: NotificationType.request,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    ),
    // December 12, 2025 notifications
    NotificationItem(
      id: 'n6',
      userId: 'u6',
      username: 'joshua_c',
      type: NotificationType.request,
      createdAt: DateTime(2025, 12, 12, 10),
    ),
    NotificationItem(
      id: 'n7',
      userId: 'u7',
      username: 'Sedha_d',
      type: NotificationType.mention,
      createdAt: DateTime(2025, 12, 12, 15),
      postId: 'p4',
    ),
    NotificationItem(
      id: 'n8',
      userId: 'u8',
      username: 'upas_r',
      type: NotificationType.mention,
      createdAt: DateTime(2025, 12, 12, 18),
      postId: 'p5',
    ),
  ];

  @override
  Future<List<NotificationItem>> getNotifications() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Sort by date (newest first)
    final sorted = List<NotificationItem>.from(_notifications);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return sorted;
  }

  @override
  Future<void> acceptRequest(String notificationId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In real app, this would call API
    // For now, we just remove the notification
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  @override
  Future<void> deleteRequest(String notificationId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In real app, this would call API
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  @override
  Future<int> getPendingRequestsCount() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Count pending requests
    return _notifications
        .where((n) => n.type == NotificationType.request)
        .length;
  }
}

