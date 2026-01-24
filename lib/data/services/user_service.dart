// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  Future<UserModel> fetchUserProfile(String userId) async {
    final response = await http.get(Uri.parse('API_URL/users/$userId'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
