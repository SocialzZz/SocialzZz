import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/notification_item.dart';
import 'package:flutter_social_media_app/data/services/notification_service.dart';
import 'notification_header.dart';
import 'notification_list_widget.dart';

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
      // Load notifications from mock service
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
      // Ignore error, use default value
      if (mounted) {
        setState(() {
          _pendingRequestsCount = 0;
        });
      }
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã chấp nhận yêu cầu kết bạn')),
      );
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã từ chối yêu cầu kết bạn')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            NotificationHeader(
              pendingRequestsCount: _pendingRequestsCount,
              accentColor: _accent,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF6B35),
                        ),
                      ),
                    )
                  : NotificationListWidget(
                      notifications: _notifications,
                      accentColor: _accent,
                      textPrimaryColor: _textPrimary,
                      textSecondaryColor: _textSecondary,
                      onAcceptRequest: _acceptRequest,
                      onDeleteRequest: _deleteRequest,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
