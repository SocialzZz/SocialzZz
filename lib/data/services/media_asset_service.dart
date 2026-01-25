import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/media_asset_model.dart';
import 'token_manager.dart';

class MediaAssetService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final TokenManager _tokenManager = TokenManager();

  /// Lấy danh sách media (image / gif)
  Future<List<MediaAssetModel>> getMediaAssets({
    String? type,       // IMAGE | GIF
    String? category,   // POST_BACKGROUND | STICKER_PACK | EMOJI_PACK | ICON_SET | GIF_COLLECTION | SEASONAL | TRENDING | FEATURED
    bool? isFeatured,
  }) async {
    try {
      final token = _tokenManager.accessToken;
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      final query = <String, String>{};
      // Chỉ gửi type, bỏ category tạm thời
      if (type != null) query['type'] = type;
      // if (category != null) query['category'] = category;
      if (isFeatured != null) query['isFeatured'] = isFeatured.toString();

      final uri = Uri.parse('$baseUrl/media-library').replace(queryParameters: query);

      print('🖼 Fetching media assets: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Status: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? jsonData;
        return data.map((e) => MediaAssetModel.fromJson(e)).toList();
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: ${jsonDecode(response.body)['message']}');
      } else {
        throw Exception('Failed to load media assets: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ MediaAsset error: $e');
      rethrow;
    }
  }
}