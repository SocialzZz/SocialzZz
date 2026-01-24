import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/services/token_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final Dio _dio = Dio();
  final TokenManager _tokenManager = TokenManager();

  // 1. Hàm Đăng Ký
  Future<Response?> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      // Lưu token sau khi đăng ký thành công
      if (response.data['access_token'] != null) {
        _tokenManager.setToken(response.data['access_token']);
        if (response.data['user']?['id'] != null) {
          _tokenManager.setUserId(response.data['user']['id']);
        }
      }

      return response;
    } on DioException catch (e) {
      // Trả về lỗi từ NestJS (ví dụ: "Email đã tồn tại")
      throw e.response?.data['message'] ?? 'Đăng ký thất bại';
    }
  }

  // 2. Hàm Đăng Nhập
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['access_token'];
      final userId = response.data['user']?['id']; // Lấy ID từ NestJS trả về

      if (token != null) {
        _tokenManager.setToken(token);
        if (userId != null) {
          // PHẢI CÓ DÒNG NÀY: Lưu ID vào SharedPreferences ngay khi login
          await saveLoginSession(userId);
          _tokenManager.setUserId(userId);
        }
      }
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveLoginSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  // Hàm lấy ID để dùng cho các màn hình khác
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();

      _tokenManager.clear();
    } catch (e) {
      print("Error during logout: $e");
    }
  }
}
