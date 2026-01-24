import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message.dart';
import 'token_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MessageService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final TokenManager _tokenManager = TokenManager();
  IO.Socket? _socket;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_tokenManager.accessToken != null)
      'Authorization': 'Bearer ${_tokenManager.accessToken}',
  };

  // Connect to WebSocket
  void connectSocket(String userId) {
    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to socket');
      _socket!.emit('register', userId);
    });

    _socket!.onDisconnect((_) => print('Disconnected from socket'));
  }

  void disconnectSocket() {
    _socket?.disconnect();
    _socket?.dispose();
  }

  // Listen for new messages
  void onNewMessage(Function(Message) callback) {
    _socket?.on('newMessage', (data) {
      callback(Message.fromJson(data));
    });
  }

  // Send message via WebSocket
  void sendMessageViaSocket(
    String senderId,
    String receiverId,
    String content,
  ) {
    _socket?.emit('sendMessage', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    });
  }

  // REST API Methods

  Future<Message> sendMessage(String receiverId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: _headers,
      body: jsonEncode({'receiverId': receiverId, 'content': content}),
    );

    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<List<Conversation>> getChatList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/conversations'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Conversation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chat list');
    }
  }

  Future<List<Message>> getConversation(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/conversations/$userId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load conversation');
    }
  }

  Future<void> markAsRead(String messageId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/messages/$messageId/read'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark message as read');
    }
  }

  Future<void> markConversationAsRead(String userId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/messages/conversations/$userId/read'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark conversation as read');
    }
  }
}
