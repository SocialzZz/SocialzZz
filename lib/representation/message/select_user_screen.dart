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
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  Future<void> _loadUsers() async {
    try {
      final token = _tokenManager.accessToken;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Load users status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _users = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('❌ Error loading users: $e');
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
          'Select User to Chat',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(
              child: Text(
                'No users found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: user['avatarUrl'] != null
                        ? NetworkImage(user['avatarUrl'])
                        : null,
                    child: user['avatarUrl'] == null
                        ? Text(
                            user['name']?.substring(0, 1).toUpperCase() ?? '?',
                            style: const TextStyle(fontSize: 20),
                          )
                        : null,
                  ),
                  title: Text(
                    user['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    user['email'] ?? '',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  trailing: Icon(
                    Icons.chat_bubble_outline,
                    color: primaryColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          partnerId: user['id'],
                          name: user['name'] ?? 'Unknown',
                          avatar: user['avatarUrl'] ?? '',
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
