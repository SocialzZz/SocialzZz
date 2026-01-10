import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final Color primaryColor = const Color(0xFFF9622E);

  final List<Map<String, String>> _onlineUsers = [
    {'name': 'Jenny', 'avatar': 'https://i.pravatar.cc/150?img=1'},
    {'name': 'Leslie', 'avatar': 'https://i.pravatar.cc/150?img=2'},
    {'name': 'Bessie', 'avatar': 'https://i.pravatar.cc/150?img=3'},
    {'name': 'Jerom', 'avatar': 'https://i.pravatar.cc/150?img=4'},
    {'name': 'Jerom', 'avatar': 'https://i.pravatar.cc/150?img=5'},
  ];

  final List<Map<String, dynamic>> _messages = [
    {'name': 'Carla Schoen', 'avatar': 'https://i.pravatar.cc/150?img=10', 'lastMessage': 'How Are You?', 'time': '09:34 PM'},
    {'name': 'Sheila Lemke', 'avatar': 'https://i.pravatar.cc/150?img=11', 'lastMessage': 'Thanks', 'time': '09:34 PM'},
    {'name': 'Deanna Botsford', 'avatar': 'https://i.pravatar.cc/150?img=12', 'lastMessage': 'Welcome!', 'time': '09:34 PM'},
    {'name': 'Katie Bergnaum', 'avatar': 'https://i.pravatar.cc/150?img=13', 'lastMessage': 'Good Morning!', 'time': '09:34 PM'},
    {'name': 'Armando Ferry', 'avatar': 'https://i.pravatar.cc/150?img=14', 'lastMessage': 'Good Morning!', 'time': '09:34 PM'},
    {'name': 'Annette Fritsch', 'avatar': 'https://i.pravatar.cc/150?img=15', 'lastMessage': 'Thanks!', 'time': '09:34 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildOnlineUsers(),
            const SizedBox(height: 16),
            Expanded(child: _buildMessageListContainer()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
          const Text('Chat', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.search, color: Colors.black, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineUsers() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _onlineUsers.length,
        itemBuilder: (context, index) {
          final user = _onlineUsers[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 28, backgroundImage: NetworkImage(user['avatar']!)),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(user['name']!, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageListContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemCount: _messages.length,
          itemBuilder: (context, index) => _buildMessageItem(_messages[index]),
        ),
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatDetailScreen(name: message['name'], avatar: message['avatar'])),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(radius: 26, backgroundImage: NetworkImage(message['avatar'])),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(message['lastMessage'], style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                ],
              ),
            ),
            Text(message['time'], style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
