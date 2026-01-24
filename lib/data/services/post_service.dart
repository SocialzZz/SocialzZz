// lib/data/services/post_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/post_model.dart';
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
}
