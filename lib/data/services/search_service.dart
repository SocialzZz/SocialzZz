import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_item.dart';
import 'package:flutter_social_media_app/representation/auth/auth_service.dart';
import 'package:flutter_social_media_app/data/services/friend_service.dart';

/// Service interface for search functionality
abstract class SearchService {
  Future<List<AccountItem>> searchAccounts(String query);
  Future<List<ReelItem>> searchReels(String query);
  Future<List<PlaceItem>> searchPlaces(String query);
  Future<List<HashtagItem>> searchHashtags(String query);
  
  Future<void> followAccount(String accountId);
  Future<void> unfollowAccount(String accountId);
}

/// Real implementation connecting to API
class RealSearchService implements SearchService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  final AuthService _authService = AuthService();

  @override
  Future<List<AccountItem>> searchAccounts(String query) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null || token.isEmpty) {
        print('❌ No access token found');
        return [];
      }

      // Gọi FriendService để search user thực từ backend
      final results = await FriendService.searchUsers(token, query);
      
      print('✅ Found ${results.length} users');
      
      List<AccountItem> accounts = [];
      
      for (var user in results) {
        if (user is Map) {
          accounts.add(AccountItem(
            id: user['_id']?.toString() ?? user['id']?.toString() ?? '',
            name: user['username']?.toString() ?? user['name']?.toString() ?? 'Unknown',
            category: user['category']?.toString() ?? user['bio']?.toString() ?? user['email']?.toString() ?? 'User',
            isFollowing: user['isFollowing'] == true || user['following'] == true || user['isFriend'] == true,
          ));
        }
      }
      
      return accounts;
      
    } catch (e) {
      print('❌ Error searching accounts: $e');
      return [];
    }
  }

  @override
  Future<List<ReelItem>> searchReels(String query) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null || token.isEmpty) {
        return [];
      }

      final url = Uri.parse('$baseUrl/posts/search?keyword=$query&type=reel');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<ReelItem> reels = [];
        
        if (jsonData['data'] is List) {
          for (var post in jsonData['data']) {
            reels.add(ReelItem(
              id: post['_id'] ?? post['id'] ?? '',
              name: post['caption'] ?? post['title'] ?? 'Reel',
              views: post['views'] ?? 0,
              authorId: post['userId'] ?? post['author'] ?? '',
            ));
          }
        }
        
        return reels;
      }
      return [];
    } catch (e) {
      print('❌ Error searching reels: $e');
      return [];
    }
  }

  @override
  Future<List<PlaceItem>> searchPlaces(String query) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null || token.isEmpty) {
        return [];
      }

      final url = Uri.parse('$baseUrl/places/search?keyword=$query');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<PlaceItem> places = [];
        
        if (jsonData['data'] is List) {
          for (var place in jsonData['data']) {
            places.add(PlaceItem(
              id: place['_id'] ?? place['id'] ?? '',
              name: place['name'] ?? 'Place',
              address: place['address'] ?? place['location'] ?? '',
            ));
          }
        }
        
        return places;
      }
      return [];
    } catch (e) {
      print('❌ Error searching places: $e');
      return [];
    }
  }

  @override
  Future<List<HashtagItem>> searchHashtags(String query) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null || token.isEmpty) {
        return [];
      }

      final url = Uri.parse('$baseUrl/hashtags/search?keyword=$query');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<HashtagItem> hashtags = [];
        
        if (jsonData['data'] is List) {
          for (var tag in jsonData['data']) {
            hashtags.add(HashtagItem(
              id: tag['_id'] ?? tag['id'] ?? '',
              name: tag['name'] ?? tag['tag'] ?? '',
              postCount: tag['postCount'] ?? tag['count'] ?? 0,
            ));
          }
        }
        
        return hashtags;
      }
      return [];
    } catch (e) {
      print('❌ Error searching hashtags: $e');
      return [];
    }
  }

  @override
  Future<void> followAccount(String accountId) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('No access token');
      }

      final url = Uri.parse('$baseUrl/users/$accountId/follow');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to follow account');
      }
    } catch (e) {
      print('❌ Error following account: $e');
      rethrow;
    }
  }

  @override
  Future<void> unfollowAccount(String accountId) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('No access token');
      }

      final url = Uri.parse('$baseUrl/users/$accountId/unfollow');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unfollow account');
      }
    } catch (e) {
      print('❌ Error unfollowing account: $e');
      rethrow;
    }
  }
}

/// Mock implementation 
class MockSearchService implements SearchService {
  // Mock data
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
      isFollowing: true,
    ),
    AccountItem(
      id: '4',
      name: 'Carla_watson',
      category: 'Business',
      isFollowing: true,
    ),
    AccountItem(
      id: '5',
      name: 'Carla_miles',
      category: 'Fashion',
      isFollowing: false,
    ),
    AccountItem(
      id: '6',
      name: 'Carlanah_nguyen',
      category: 'Business',
      isFollowing: true,
    ),
    AccountItem(
      id: '7',
      name: 'Carlatin_watson',
      category: 'Fashion',
      isFollowing: false,
    ),
    AccountItem(
      id: '8',
      name: 'Carla_fisher',
      category: 'Business',
      isFollowing: true,
    ),
    AccountItem(
      id: '9',
      name: 'kristin_watson',
      category: 'Fashion',
      isFollowing: true,
    ),
  ];

  final List<ReelItem> _mockReels = [
    ReelItem(
      id: 'r1',
      name: 'Fashion Trends 2024',
      views: 125000,
      authorId: '1',
    ),
    ReelItem(
      id: 'r2',
      name: 'Art Showcase',
      views: 89000,
      authorId: '3',
    ),
    ReelItem(
      id: 'r3',
      name: 'Business Tips',
      views: 156000,
      authorId: '4',
    ),
  ];

  final List<PlaceItem> _mockPlaces = [
    PlaceItem(
      id: 'p1',
      name: 'New York Fashion District',
      address: 'New York, NY',
    ),
    PlaceItem(
      id: 'p2',
      name: 'Los Angeles Art Gallery',
      address: 'Los Angeles, CA',
    ),
    PlaceItem(
      id: 'p3',
      name: 'San Francisco Business Center',
      address: 'San Francisco, CA',
    ),
  ];

  final List<HashtagItem> _mockHashtags = [
    HashtagItem(
      id: 'h1',
      name: 'fashion',
      postCount: 1250000,
    ),
    HashtagItem(
      id: 'h2',
      name: 'art',
      postCount: 890000,
    ),
    HashtagItem(
      id: 'h3',
      name: 'business',
      postCount: 560000,
    ),
  ];

  @override
  Future<List<AccountItem>> searchAccounts(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return _mockAccounts;
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockAccounts
        .where((account) =>
            account.name.toLowerCase().contains(lowerQuery) ||
            (account.category?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  @override
  Future<List<ReelItem>> searchReels(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return _mockReels;
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockReels
        .where((reel) => reel.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<List<PlaceItem>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return _mockPlaces;
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockPlaces
        .where((place) =>
            place.name.toLowerCase().contains(lowerQuery) ||
            (place.address?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  @override
  Future<List<HashtagItem>> searchHashtags(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return _mockHashtags;
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockHashtags
        .where((hashtag) => hashtag.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<void> followAccount(String accountId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _mockAccounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      _mockAccounts[index] = _mockAccounts[index].copyWith(isFollowing: true);
    }
  }

  @override
  Future<void> unfollowAccount(String accountId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _mockAccounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      _mockAccounts[index] = _mockAccounts[index].copyWith(isFollowing: false);
    }
  }
}

