import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/services/token_manager.dart';
import 'chat_detail_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({super.key});

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  final Color primaryColor = const Color(0xFFF9622E);
  final TokenManager _tokenManager = TokenManager();
  List<dynamic> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriendsList();
  }

  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  Future<void> _loadFriendsList() async {
    try {
      final token = _tokenManager.accessToken;

      final response = await http.get(
        Uri.parse('$baseUrl/messages/friends/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Load friends list status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final friendsData = jsonDecode(response.body);
        setState(() {
          _friends = friendsData;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load friends');
      }
    } catch (e) {
      print('❌ Error loading friends: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Danh sách bạn bè',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _friends.isEmpty
          ? const Center(
              child: Text(
                'Bạn chưa có bạn bè nào',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friendData = _friends[index];
                final friend = friendData['friend'];
                final lastMessage = friendData['lastMessage'];
                final unreadCount = friendData['unreadCount'] ?? 0;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: friend['avatarUrl'] != null
                        ? NetworkImage(friend['avatarUrl'])
                        : null,
                    child: friend['avatarUrl'] == null
                        ? Text(
                            friend['name']?.substring(0, 1).toUpperCase() ??
                                '?',
                            style: const TextStyle(fontSize: 20),
                          )
                        : null,
                  ),
                  title: Text(
                    friend['name'] ?? 'Không rõ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    lastMessage != null
                        ? (lastMessage['content'] ?? '').length > 40
                              ? '${(lastMessage['content'] ?? '').substring(0, 40)}...'
                              : (lastMessage['content'] ?? '')
                        : 'Chưa có tin nhắn',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: unreadCount > 0
                      ? Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Icon(Icons.chat_bubble_outline, color: primaryColor),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          partnerId: friend['id'],
                          name: friend['name'] ?? 'Không rõ',
                          avatar: friend['avatarUrl'] ?? '',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
