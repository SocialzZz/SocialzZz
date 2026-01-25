import 'dart:convert';
import 'package:http/http.dart' as http;

class FriendService {
  static const String baseUrl = "http://10.0.2.2:3000"; 
  // Android emulator: localhost = 10.0.2.2

  static Map<String, String> headers(String token) => {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token"
  };

  /// Lấy danh sách yêu cầu kết bạn
  static Future<List> getFriendRequests(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/friends/requests"),
      headers: headers(token),
    );
    return jsonDecode(res.body);
  }

  /// Gửi yêu cầu kết bạn
  static Future<bool> sendFriendRequest(String token, String userId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/friends/request/$userId"),
      headers: headers(token),
    );
    return res.statusCode == 200;
  }

  /// Chấp nhận
  static Future<bool> acceptRequest(String token, String userId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/friends/accept/$userId"),
      headers: headers(token),
    );
    return res.statusCode == 200;
  }

  /// Từ chối
  static Future<bool> rejectRequest(String token, String userId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/friends/reject/$userId"),
      headers: headers(token),
    );
    return res.statusCode == 200;
  }

  /// Xóa bạn
  static Future<bool> removeFriend(String token, String userId) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/friends/$userId"),
      headers: headers(token),
    );
    return res.statusCode == 200;
  }

  /// Danh sách bạn bè
  static Future<List> getFriends(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/friends"),
      headers: headers(token),
    );
    return jsonDecode(res.body);
  }

  /// Gợi ý bạn bè
  static Future<List> getSuggestions(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/friends/suggestions"),
      headers: headers(token),
    );
    return jsonDecode(res.body);
  }

  /// Bạn chung
  static Future<List> getMutualFriends(String token, String userId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/friends/mutual/$userId"),
      headers: headers(token),
    );
    return jsonDecode(res.body);
  }

  /// Kiểm tra bạn bè
  static Future<bool> checkFriend(String token, String userId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/friends/check/$userId"),
      headers: headers(token),
    );
    final data = jsonDecode(res.body);
    return data["isFriend"];
  }

  /// Tìm kiếm user
  static Future<List> searchUsers(String token, String keyword) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/users/search?keyword=$keyword"),
        headers: headers(token),
      );
      
      print('🔍 Search API Response: ${res.statusCode}');
      print('📦 Body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data is List ? data : (data['data'] ?? data['users'] ?? []);
      }
      return [];
    } catch (e) {
      print('❌ Error searching users: $e');
      return [];
    }
  }
}
