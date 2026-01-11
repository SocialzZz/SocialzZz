import 'package:flutter/material.dart';

import 'message_header.dart';
import 'online_user_list.dart';
import 'message_item.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final Color primaryColor = const Color(0xFFF9622E);

  // DỮ LIỆU GIẢ LẬP
  final List<Map<String, String>> _onlineUsers = [
    {'name': 'Jenny', 'avatar': 'https://i.pravatar.cc/150?img=1'},
    {'name': 'Leslie', 'avatar': 'https://i.pravatar.cc/150?img=2'},
    {
      'name': 'Bessie',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      /* ... dữ liệu khác */
    },
    {'name': 'Jerom', 'avatar': 'https://i.pravatar.cc/150?img=4'},
    {'name': 'Jerom', 'avatar': 'https://i.pravatar.cc/150?img=5'},
  ];

  final List<Map<String, dynamic>> _messages = [
    {
      'name': 'Carla Schoen',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'lastMessage': 'How Are You?',
      'time': '09:34 PM',
    },
    {
      'name': 'Sheila Lemke',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'lastMessage': 'Thanks',
      'time': '09:34 PM',
    },
    {
      'name': 'Deanna Botsford',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'lastMessage': 'Welcome!',
      'time': '09:34 PM',
    },
    {
      'name': 'Katie Bergnaum',
      'avatar': 'https://i.pravatar.cc/150?img=13',
      'lastMessage': 'Good Morning!',
      'time': '09:34 PM',
    },
    {
      'name': 'Armando Ferry',
      'avatar': 'https://i.pravatar.cc/150?img=14',
      'lastMessage': 'Good Morning!',
      'time': '09:34 PM',
    },
    {
      'name': 'Annette Fritsch',
      'avatar': 'https://i.pravatar.cc/150?img=15',
      'lastMessage': 'Thanks!',
      'time': '09:34 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          // 1. Header (Dùng widget mới)
          const SafeArea(bottom: false, child: MessageHeader()),

          // 2. Danh sách người dùng
          OnlineUserList(primaryColor: primaryColor, onlineUsers: _onlineUsers),

          const SizedBox(height: 20),

          // 3. Danh sách tin nhắn chính
          Expanded(child: _buildMessageListContainer()),
        ],
      ),
    );
  }

  Widget _buildMessageListContainer() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          itemCount: _messages.length,
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Divider(height: 1, color: Color(0xFFF1F1F1)),
          ),
          itemBuilder: (context, index) => MessageItem(
            message: _messages[index],
            primaryColor: primaryColor,
          ),
        ),
      ),
    );
  }
}
