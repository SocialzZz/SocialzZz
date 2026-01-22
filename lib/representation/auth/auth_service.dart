import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/services/token_manager.dart';

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

      // NestJS trả về { access_token: "...", user: {...} }
      final token = response.data['access_token'];
      if (token != null) {
        _tokenManager.setToken(token);
        if (response.data['user']?['id'] != null) {
          _tokenManager.setUserId(response.data['user']['id']);
        }
      }
      
      return token;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Sai tài khoản hoặc mật khẩu';
    }
  }

  // 3. Hàm Đăng Xuất
  void logout() {
    _tokenManager.clear();
  }
}
