import 'package:flutter/material.dart';
import '../../data/services/message_service.dart';
import '../../data/services/token_manager.dart';
import '../../data/models/message.dart';
import 'message_header.dart';
import 'message_item.dart';
import 'select_user_screen.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final Color primaryColor = const Color(0xFFF9622E);
  final MessageService _messageService = MessageService();
  final TokenManager _tokenManager = TokenManager();
  List<Conversation> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _setupRealtimeUpdates();
  }

  Future<void> _loadConversations() async {
    try {
      final conversations = await _messageService.getChatList();
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading conversations: $e');
      setState(() => _isLoading = false);
    }
  }

  void _setupRealtimeUpdates() {
    final userId = _tokenManager.userId;
    if (userId != null) {
      _messageService.connectSocket(userId);
      _messageService.onNewMessage((message) {
        _loadConversations(); // Reload conversations when new message arrives
      });
    }
  }

  @override
  void dispose() {
    _messageService.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          const SafeArea(bottom: false, child: MessageHeader()),
          const SizedBox(height: 20),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _conversations.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadConversations,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: _conversations.length,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Divider(height: 1, color: Color(0xFFF1F1F1)),
                      ),
                      itemBuilder: (context, index) {
                        final conversation = _conversations[index];
                        return MessageItem(
                          conversation: conversation,
                          primaryColor: primaryColor,
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
