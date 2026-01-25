// lib/representation/auth/auth_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/services/token_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      return response;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Đăng ký thất bại';
    }
  }

  // 2. HÀM ĐĂNG NHẬP THƯỜNG
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );

      print('📦 Login response: ${response.data}');

      // ⭐ FIX: Backend trả về "access_token" (do dùng generateTokens)
      final token = response.data['access_token']; // ✅ ĐÚNG
      final userId = response.data['user']?['id'];

      print('🔍 Token from response: ${token?.substring(0, 20)}...');
      print('🔍 User ID: $userId');

      if (token != null) {
        _tokenManager.setToken(token);
        await saveAccessToken(token);

        if (userId != null) {
          await saveLoginSession(userId);
          _tokenManager.setUserId(userId);
        }

        final savedToken = await getAccessToken();
        print('✅ Token saved: ${savedToken?.substring(0, 20)}...');
      }

      return token;
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  // 3. HÀM ĐĂNG NHẬP GOOGLE
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
  );

  Future<String?> loginWithGoogle() async {
    try {
      print('🔵 Starting Google Sign-In...');

      // 1. Mở trình chọn tài khoản Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('❌ User cancelled Google Sign-In');
        return null;
      }

      print('✅ Google account selected: ${googleUser.email}');

      // 2. Lấy thông tin xác thực (idToken)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print('❌ No idToken received from Google');
        return null;
      }

      print('🔑 idToken received: ${idToken.substring(0, 20)}...');

      // 3. Gửi idToken lên Backend
      final response = await _dio.post(
        '$baseUrl/auth/google',
        data: {'token': idToken},
      );

      print('📦 Google Login Backend response: ${response.data}');

      // 4. Lấy token từ response
      final token =
          response.data['access_token']; // ✅ Backend trả về "access_token"
      final userId = response.data['user']?['id'];

      print('🔍 Access token: ${token?.substring(0, 20)}...');
      print('🔍 User ID: $userId');

      if (token != null) {
        // Lưu token
        _tokenManager.setToken(token);
        await saveAccessToken(token);

        if (userId != null) {
          _tokenManager.setUserId(userId);
          await saveUserId(userId);
        }

        print('✅ Google Login successful, token saved!');
        return token;
      } else {
        print('❌ No token in backend response');
        return null;
      }
    } on DioException catch (e) {
      print('❌ Google Backend error: ${e.response?.data}');
      print('❌ Status code: ${e.response?.statusCode}');
      throw e.response?.data['message'] ?? 'Lỗi xác thực với server';
    } catch (e) {
      print('❌ Google Sign-In error: $e');
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
    return token;
  }

  Future<void> logout() async {
    try {
      // Đăng xuất Google
      await _googleSignIn.signOut();

      // Đăng xuất Supabase
      await Supabase.instance.client.auth.signOut();

      // Xóa token
      _tokenManager.clear();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('user_id');

      print('✅ Logged out successfully');
    } catch (e) {
      print("❌ Error during logout: $e");
    }
  }
}
