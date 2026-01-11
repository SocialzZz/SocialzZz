import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/notification_item.dart';
import 'package:flutter_social_media_app/data/services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = MockNotificationService();
  List<NotificationItem> _notifications = [];
  int _pendingRequestsCount = 0;
  bool _isLoading = false;

  final Color _accent = const Color(0xFFFF6B35);
  final Color _textPrimary = const Color(0xFF212121);
  final Color _textSecondary = const Color(0xFF757575);

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _loadPendingRequestsCount();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await _notificationService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  Future<void> _loadPendingRequestsCount() async {
    try {
      final count = await _notificationService.getPendingRequestsCount();
      if (mounted) {
        setState(() {
          _pendingRequestsCount = count;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _acceptRequest(NotificationItem notification) async {
    // Optimistic update
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
      _pendingRequestsCount = _pendingRequestsCount > 0
          ? _pendingRequestsCount - 1
          : 0;
    });

    try {
      await _notificationService.acceptRequest(notification.id);
    } catch (e) {
      // Rollback on error
      setState(() {
        _notifications.add(notification);
        _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _pendingRequestsCount++;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  Future<void> _deleteRequest(NotificationItem notification) async {
    // Optimistic update
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
      _pendingRequestsCount = _pendingRequestsCount > 0
          ? _pendingRequestsCount - 1
          : 0;
    });

    try {
      await _notificationService.deleteRequest(notification.id);
    } catch (e) {
      // Rollback on error
      setState(() {
        _notifications.add(notification);
        _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _pendingRequestsCount++;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF6B35),
                        ),
                      ),
                    )
                  : _buildNotificationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(
            child: Text(
              'Notification',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
          ),
          if (_pendingRequestsCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '$_pendingRequestsCount Requests',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _accent,
                ),
              ),
            )
          else
            const SizedBox(width: 100), // Spacer to center title
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    if (_notifications.isEmpty) {
      return const Center(
        child: Text(
          'No notifications',
          style: TextStyle(color: Color(0xFF757575)),
        ),
      );
    }

    // Group notifications by date
    final groupedNotifications = <String, List<NotificationItem>>{};
    for (final notification in _notifications) {
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
        final notifications = groupedNotifications[dateLabel]!;

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
                  color: _textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...notifications.map(
              (notification) => _buildNotificationItem(notification),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AvatarPlaceholder(
            accent: _accent,
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
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.actionText,
                  style: TextStyle(fontSize: 14, color: _textSecondary),
                ),
              ],
            ),
          ),
          if (notification.type == NotificationType.request) ...[
            const SizedBox(width: 8),
            _buildRequestButtons(notification),
          ] else if (notification.postImageUrl != null ||
              notification.postId != null) ...[
            const SizedBox(width: 8),
            _PostPreviewPlaceholder(accent: _accent),
          ],
        ],
      ),
    );
  }

  Widget _buildRequestButtons(NotificationItem notification) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _acceptRequest(notification),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Accept',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _deleteRequest(notification),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _accent, width: 1.4),
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                color: _accent,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.accent, this.imageUrl});

  final Color accent;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFFF3F4F6),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Icon(Icons.landscape, size: 20, color: accent.withAlpha(153))
          : null,
    );
  }
}

class _PostPreviewPlaceholder extends StatelessWidget {
  const _PostPreviewPlaceholder({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(Icons.landscape, size: 24, color: accent.withAlpha(153)),
    );
  }
}
