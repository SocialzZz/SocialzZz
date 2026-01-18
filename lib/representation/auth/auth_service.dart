import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final Dio _dio = Dio();

  // 1. Hàm Đăng Ký
  Future<Response?> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
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

      // NestJS trả về { access_token: "..." }
      return response.data['access_token'];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Sai tài khoản hoặc mật khẩu';
    }
  }
}
