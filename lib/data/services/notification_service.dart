import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/notification_item.dart';
import 'token_manager.dart';

/// Service interface for notification functionality
abstract class NotificationService {
  Future<List<NotificationItem>> getNotifications();
  Future<void> acceptRequest(String userId);
  Future<void> deleteRequest(String notificationId);
  Future<void> unfriend(String friendId);
  Future<int> getPendingRequestsCount();
}

/// Real implementation gọi API
class RealNotificationService implements NotificationService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final TokenManager _tokenManager = TokenManager();

  Future<String?> _getToken() async {
    return _tokenManager.accessToken;
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('🔔 Fetching notifications');

      final response = await http.get(
        Uri.parse('$baseUrl/notifications?page=1&limit=20'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? jsonData;

        return data.map((notif) {
          // Parse request status if it's a friend request
          FriendRequestStatus? requestStatus;
          if (notif['status'] != null) {
            String status = notif['status'].toString().toUpperCase();
            if (status == 'PENDING') {
              requestStatus = FriendRequestStatus.pending;
            } else if (status == 'ACCEPTED') {
              requestStatus = FriendRequestStatus.accepted;
            } else if (status == 'REJECTED') {
              requestStatus = FriendRequestStatus.rejected;
            }
          }

          return NotificationItem(
            id: notif['id'],
            userId: notif['actorId'] ?? '',
            username: notif['actor']?['name'] ?? 'Unknown',
            type: _parseNotificationType(notif['type']),
            requestStatus: requestStatus,
            createdAt: DateTime.parse(notif['createdAt']),
            postId: notif['entityId'],
            userImageUrl: notif['actor']?['avatarUrl'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      rethrow;
    }
  }

  @override
  Future<void> acceptRequest(String userId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('✅ Accepting friend request from: $userId');

      // Use userId in path parameter, not query parameter
      final response = await http.post(
        Uri.parse('$baseUrl/friends/accept/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Accept status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to accept request');
      }

      print('✅ Friend request accepted successfully');
    } catch (e) {
      print('❌ Error accepting request: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteRequest(String notificationId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('❌ Rejecting friend request: $notificationId');

      final response = await http.post(
        Uri.parse('$baseUrl/friends/reject/$notificationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Reject status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to reject request: ${response.statusCode}');
      }

      print('✅ Friend request rejected successfully');
    } catch (e) {
      print('❌ Error rejecting request: $e');
      rethrow;
    }
  }

  @override
  Future<void> unfriend(String friendId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('👋 Removing friend: $friendId');

      final response = await http.delete(
        Uri.parse('$baseUrl/friends/$friendId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Unfriend status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to unfriend: ${response.statusCode}');
      }

      print('✅ Friend removed successfully');
    } catch (e) {
      print('❌ Error unfriending: $e');
      rethrow;
    }
  }

  @override
  Future<int> getPendingRequestsCount() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('📊 Fetching pending requests count');

      final response = await http.get(
        Uri.parse('$baseUrl/notifications?page=1&limit=100'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? jsonData;

        // Count FRIEND_REQUEST notifications
        final count = data.where((n) => n['type'] == 'FRIEND_REQUEST').length;

        print('📊 Pending requests: $count');
        return count;
      } else {
        throw Exception('Failed to get pending count');
      }
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  // Helper: convert string type to NotificationType enum
  NotificationType _parseNotificationType(String type) {
    switch (type.toUpperCase()) {
      case 'FRIEND_REQUEST':
        return NotificationType.request;
      case 'FRIEND_ACCEPTED':
        return NotificationType.accepted;
      case 'POST_LIKE':
        return NotificationType.like;
      case 'POST_TAG':
      case 'POST_COMMENT':
      case 'COMMENT_REPLY':
        return NotificationType.mention;
      default:
        return NotificationType.mention;
    }
  }
}

/// Mock implementation
class MockNotificationService implements NotificationService {
  final List<NotificationItem> _notifications = [
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
    await Future.delayed(const Duration(milliseconds: 300));
    final sorted = List<NotificationItem>.from(_notifications);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<void> acceptRequest(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _notifications.removeWhere((n) => n.userId == userId);
  }

  @override
  Future<void> deleteRequest(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  @override
  Future<void> unfriend(String friendId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _notifications.removeWhere((n) => n.userId == friendId);
  }

  @override
  Future<int> getPendingRequestsCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _notifications
        .where((n) => n.type == NotificationType.request)
        .length;
  }
}
