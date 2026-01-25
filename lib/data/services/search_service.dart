import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/search_item.dart';
import 'token_manager.dart';

/// Service interface for search functionality
abstract class SearchService {
  Future<List<AccountItem>> searchAccounts(String query);
  Future<List<ReelItem>> searchReels(String query);
  Future<List<PlaceItem>> searchPlaces(String query);
  Future<List<HashtagItem>> searchHashtags(String query);

  Future<void> followAccount(String accountId);
  Future<void> cancelRequest(String accountId);
  Future<void> unfollowAccount(String accountId);
}

/// Real implementation gọi API
class RealSearchService implements SearchService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final TokenManager _tokenManager = TokenManager();

  Future<String?> _getToken() async {
    return _tokenManager.accessToken;
  }

  @override
  Future<List<AccountItem>> searchAccounts(String query) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('🔍 Searching accounts: $query');

      final response = await http.get(
        Uri.parse('$baseUrl/friends/search?q=$query&limit=20'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData is List
            ? jsonData
            : jsonData['data'] ?? [];

        return data.map((user) {
          bool requestSent = user['requestSent'] ?? false;
          bool requestReceived = user['requestReceived'] ?? false;
          bool isFriend = user['isFriend'] ?? false;

          return AccountItem(
            id: user['id'] ?? '',
            name: user['name'] ?? 'Unknown',
            category: user['email'],
            imageUrl: user['avatarUrl'],
            isFollowing: requestSent || isFriend, // For backward compatibility
            requestSent: requestSent,
            requestReceived: requestReceived,
            isFriend: isFriend,
          );
        }).toList();
      } else {
        throw Exception('Failed to search accounts: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error searching accounts: $e');
      rethrow;
    }
  }

  @override
  Future<List<ReelItem>> searchReels(String query) async {
    // Mock data - giữ nguyên cũ
    return [
      ReelItem(
        id: 'r1',
        name: 'Fashion Trends 2024',
        views: 125000,
        authorId: '1',
      ),
      ReelItem(id: 'r2', name: 'Art Showcase', views: 89000, authorId: '3'),
      ReelItem(id: 'r3', name: 'Business Tips', views: 156000, authorId: '4'),
    ];
  }

  @override
  Future<List<PlaceItem>> searchPlaces(String query) async {
    // Mock data - giữ nguyên cũ
    return [
      PlaceItem(
        id: 'p1',
        name: 'New York Fashion District',
        address: 'New York, NY',
      ),
      PlaceItem(
        id: 'p2',
        name: 'Paris Fashion Week Venue',
        address: 'Paris, France',
      ),
      PlaceItem(
        id: 'p3',
        name: 'Milan Fashion Capital',
        address: 'Milan, Italy',
      ),
    ];
  }

  @override
  Future<List<HashtagItem>> searchHashtags(String query) async {
    // Mock data - giữ nguyên cũ
    return [
      HashtagItem(id: 'h1', name: '#Fashion', postCount: 156000),
      HashtagItem(id: 'h2', name: '#Lifestyle', postCount: 89000),
      HashtagItem(id: 'h3', name: '#Photography', postCount: 234000),
    ];
  }

  @override
  Future<void> followAccount(String accountId) async {
    // Không cần implement - chỉ search thôi
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('👤 Sending friend request to: $accountId');

      final response = await http.post(
        Uri.parse('$baseUrl/friends/request/$accountId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}), // ← Thêm empty body
      );

      print('📡 Friend request status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        throw Exception(
          errorBody['message'] ?? 'Failed to send friend request',
        );
      }

      print('✅ Friend request sent successfully');
    } catch (e) {
      print('❌ Error sending friend request: $e');
      rethrow;
    }
  }

  @override
  Future<void> unfollowAccount(String accountId) async {
    // Không cần implement - chỉ search thôi
    print('⚠️ Unfollow feature not implemented');
  }

  @override
  Future<void> cancelRequest(String accountId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('❌ Canceling friend request to: $accountId');

      final response = await http.post(
        Uri.parse('$baseUrl/friends/reject/$accountId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Cancel status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to cancel request');
      }

      print('✅ Friend request canceled successfully');
    } catch (e) {
      print('❌ Error canceling friend request: $e');
      rethrow;
    }
  }
}

/// Mock implementation
class MockSearchService implements SearchService {
  final List<AccountItem> _mockAccounts = [
    AccountItem(
      id: '1',
      name: 'carla_choen',
      category: 'Fashion',
      isFollowing: false,
    ),
    AccountItem(
      id: '2',
      name: 'Carla_mCoy',
      category: 'Fashion',
      isFollowing: false,
    ),
    AccountItem(
      id: '3',
      name: 'Carla_bell',
      category: 'Artist',
      isFollowing: false,
    ),
  ];

  final List<ReelItem> _mockReels = [
    ReelItem(
      id: 'r1',
      name: 'Fashion Trends 2024',
      views: 125000,
      authorId: '1',
    ),
    ReelItem(id: 'r2', name: 'Art Showcase', views: 89000, authorId: '3'),
  ];

  final List<PlaceItem> _mockPlaces = [
    PlaceItem(
      id: 'p1',
      name: 'New York Fashion District',
      address: 'New York, NY',
    ),
    PlaceItem(
      id: 'p2',
      name: 'Paris Fashion Week Venue',
      address: 'Paris, France',
    ),
  ];

  final List<HashtagItem> _mockHashtags = [
    HashtagItem(id: 'h1', name: '#Fashion', postCount: 156000),
    HashtagItem(id: 'h2', name: '#Lifestyle', postCount: 89000),
  ];

  @override
  Future<List<AccountItem>> searchAccounts(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAccounts
        .where((a) => a.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<ReelItem>> searchReels(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockReels
        .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<PlaceItem>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPlaces
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<HashtagItem>> searchHashtags(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockHashtags
        .where((h) => h.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<void> followAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('✅ Mock: Friend request sent to $accountId');
  }

  @override
  Future<void> unfollowAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('✅ Mock: Canceled friend request to $accountId');
  }

  @override
  Future<void> cancelRequest(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('✅ Mock: Canceled friend request to $accountId');
  }
}
