// lib/data/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_social_media_app/data/models/user_model.dart';
import 'package:flutter_social_media_app/representation/auth/auth_service.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  final AuthService _authService = AuthService();

  Future<UserModel> fetchUserProfile(String userId) async {
    try {
      // Lấy access token
      final token = await _authService.getAccessToken();

      if (token == null || token.isEmpty) {
        throw Exception('No access token found. Please login again.');
      }

      final url = Uri.parse('$baseUrl/auth/me');
      print('🔍 Fetching profile from: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return UserModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to load user (${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error fetching profile: $e');
      rethrow;
    }
  }
}
