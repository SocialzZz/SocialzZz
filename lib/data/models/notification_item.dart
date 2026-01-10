/// Notification types
enum NotificationType {
  request,   // Friend request
  like,      // Post like
  mention,   // Mention in post
}

/// Notification model
class NotificationItem {
  final String id;
  final String userId;
  final String username;
  final String? userImageUrl;
  final NotificationType type;
  final DateTime createdAt;
  final String? postId;
  final String? postImageUrl;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.username,
    this.userImageUrl,
    required this.type,
    required this.createdAt,
    this.postId,
    this.postImageUrl,
  });

  String get actionText {
    switch (type) {
      case NotificationType.request:
        return 'Sent a Request.';
      case NotificationType.like:
        return 'Liked your Post.';
      case NotificationType.mention:
        return 'Mentioned You in a Post.';
    }
  }

  /// Check if notification is from today
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  /// Check if notification is from yesterday
  bool get isYesterday {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return createdAt.year == yesterday.year &&
        createdAt.month == yesterday.month &&
        createdAt.day == yesterday.day;
  }

  /// Get formatted date label
  String get dateLabel {
    if (isToday) return 'TODAY';
    if (isYesterday) return 'YESTERDAY';
    
    // Format: "DECEMBER 12, 2025"
    const months = [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year}';
  }
}

