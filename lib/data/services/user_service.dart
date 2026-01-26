import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import 'token_manager.dart';

class UserService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final TokenManager _tokenManager = TokenManager();

  Future<UserModel> fetchUserProfile(String userId) async {
    try {
      final token = _tokenManager.accessToken;

      if (token == null || token.isEmpty) {
        print('⚠️ No token found in TokenManager');
        throw Exception('No access token found. Please login again.');
      }

      print('🔑 Using token: ${token.substring(0, 20)}...');

      final url = Uri.parse('$baseUrl/users/$userId');
      print('🔍 Fetching profile from: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('📦 Parsed JSON: $jsonData');

        // Xử lý nếu API trả về dưới `data` field
        final userData = jsonData['data'] ?? jsonData;
        print('👤 User Data: $userData');

        final user = UserModel.fromJson(userData);
        print('✅ User loaded: ${user.name} - ${user.avatarUrl}');

        return user;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception(
          'Failed to load user (${response.statusCode}) - ${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error fetching profile: $e');
      rethrow;
    }
  }

  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? dob,
  }) async {
    try {
      final token = _tokenManager.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('No access token found. Please login again.');
      }

      final url = Uri.parse('$baseUrl/users/$userId');
      print('🔄 Updating profile: $url');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
          if (dob != null) 'dob': dob,
        }),
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userData = jsonData['data'] ?? jsonData;
        final user = UserModel.fromJson(userData);
        print('✅ Profile updated: ${user.name}');
        return user;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to update profile (${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }
}
