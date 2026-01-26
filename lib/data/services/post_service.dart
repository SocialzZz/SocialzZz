// lib/data/services/post_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import 'token_manager.dart';

class PostService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final TokenManager _tokenManager = TokenManager();

  Future<List<PostModel>> getPosts({int page = 1, int limit = 10}) async {
    try {
      final token = _tokenManager.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      print('🔍 Fetching posts - Page: $page, Limit: $limit');

      final response = await http.get(
        Uri.parse('$baseUrl/posts?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Get posts status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> postsData = jsonData['data'];

        return postsData.map((json) => PostModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching posts: $e');
      rethrow;
    }
  }

  Future<PostModel> createPost({
    required String content,
    required String privacy,
    List<String>? mediaUrls,
    String? feeling,
    String? location,
    List<String>? taggedFriends,
    List<String>? hashtags,
  }) async {
    try {
      final token = _tokenManager.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('No access token found - Please login again');
      }

      print('📝 Creating post...');
      print('🔗 URL: $baseUrl/posts');

      // Convert privacy to uppercase (PUBLIC, FRIENDS, PRIVATE)
      final privacyUpper = privacy.toUpperCase();

      final body = {
        'content': content,
        'privacy': privacyUpper,
        'mediaUrls': mediaUrls ?? [],
        if (feeling != null) 'feeling': feeling,
        if (location != null) 'location': location,
        if (hashtags != null && hashtags.isNotEmpty) 'hashtags': hashtags,
        // Bỏ taggedFriends vì backend không support
      };

      print('📤 Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('📡 Create post status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final postData = jsonData['data'] ?? jsonData;
        return PostModel.fromJson(postData);
      } else if (response.statusCode == 400) {
        final jsonData = jsonDecode(response.body);
        final errorMessage = jsonData['message'] ?? 'Bad request';
        throw Exception('Validation error: $errorMessage');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        final errorBody = response.body;
        throw Exception(
          'Failed to create post: ${response.statusCode} - $errorBody',
        );
      }
    } catch (e) {
      print('❌ Error creating post: $e');
      rethrow;
    }
  }

  Future<List<CommentModel>> getComments(String postId, {int page = 1, int limit = 20}) async {
    try {
      final token = await _tokenManager.accessToken;
      if (token == null) throw Exception('No access token');

      // URL Query params: ?page=1&limit=20
      final url = Uri.parse('$baseUrl/posts/$postId/comments?page=$page&limit=$limit');
      
      print('🔍 Fetching comments: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Comments Response Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        // Backend trả về: { "data": [...], "meta": {...} }
        final List<dynamic> rawList = jsonData['data'] ?? [];
        
        // MAP DỮ LIỆU: Backend trả 'author', Model cần 'user'
        final mappedList = rawList.map((item) {
          if (item is Map<String, dynamic>) {
            // Nếu có key 'author' mà chưa có 'user', gán 'author' sang 'user'
            if (item.containsKey('author') && !item.containsKey('user')) {
              item['user'] = item['author'];
            }
          }
          return item;
        }).toList();

        return mappedList.map((e) => CommentModel.fromJson(e)).toList();
      } else {
        print('❌ Failed response: ${response.body}');
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching comments: $e');
      return []; // Trả về list rỗng thay vì crash để UI vẫn hiển thị
    }
  }

  Future<CommentModel> addComment(String postId, String content) async {
    try {
      final token = await _tokenManager.accessToken;
      final url = Uri.parse('$baseUrl/posts/$postId/comments');

      print('📝 Adding comment to $postId: $content');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'content': content,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final dynamic rawData = jsonData['data'] ?? jsonData;
        
        // MAP DỮ LIỆU cho Single Item
        if (rawData is Map<String, dynamic>) {
           if (rawData.containsKey('author') && !rawData.containsKey('user')) {
              rawData['user'] = rawData['author'];
            }
        }

        print('✅ Comment added successfully');
        return CommentModel.fromJson(rawData);
      } else {
        throw Exception('Failed to post comment: ${response.body}');
      }
    } catch (e) {
      print('❌ Error posting comment: $e');
      rethrow;
    }
  }
}
