// lib/representation/auth/auth_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/services/token_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final Dio _dio = Dio();
  final TokenManager _tokenManager = TokenManager();

  // 1. HÀM ĐĂNG KÝ
  Future<Response?> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      print('📦 Register response: ${response.data}');

      // Backend register không trả token, chỉ trả message
      return response;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Đăng ký thất bại';
    }
  }

  // 2. HÀM ĐĂNG NHẬP
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );

      print('📦 Login response: ${response.data}');

      // ⭐ FIX: Backend trả về "accessToken" không phải "access_token"
      final token = response
          .data['accessToken']; // ← ĐỔI TỪ access_token SANG accessToken
      final userId = response.data['user']?['id'];

      print('🔍 Token from response: ${token?.substring(0, 20)}...');
      print('🔍 User ID: $userId');

      if (token != null) {
        // Lưu vào TokenManager
        _tokenManager.setToken(token);

        // Lưu vào SharedPreferences
        await saveAccessToken(token);

        if (userId != null) {
          await saveLoginSession(userId);
          _tokenManager.setUserId(userId);
        }

        // Xác nhận đã lưu
        final savedToken = await getAccessToken();
        print(
          '✅ Token saved to SharedPreferences: ${savedToken?.substring(0, 20)}...',
        );
      }

      return token;
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  Future<void> saveLoginSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    print('💾 Saved token to SharedPreferences');
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print('🔑 Retrieved token: ${token?.substring(0, 20) ?? "null"}...');
    return token;
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      _tokenManager.clear();

      // Xóa khỏi SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('user_id');
    } catch (e) {
      print("Error during logout: $e");
    }
  }
}
