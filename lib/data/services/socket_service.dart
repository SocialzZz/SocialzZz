import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'token_manager.dart';

class SocketService {
  IO.Socket? _socket;
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final TokenManager _tokenManager = TokenManager();

  // Kết nối Socket
  Future<void> connect() async {
    try {
      final token = await _tokenManager.accessToken;
      
      // Nếu đang kết nối rồi thì thôi
      if (_socket != null && _socket!.connected) {
        print('⚡ Socket already connected');
        return;
      }

      print('🔌 Connecting to socket at $baseUrl');

      _socket = IO.io(baseUrl, IO.OptionBuilder()
        .setTransports(['websocket']) // Bắt buộc dùng websocket
        .setExtraHeaders({'Authorization': 'Bearer $token'})
        .disableAutoConnect()
        .enableForceNew()
        .build()
      );

      _socket?.connect();

      _socket?.onConnect((_) {
        print('⚡ Socket Connected ID: ${_socket?.id}');
      });

      _socket?.onConnectError((data) => print('❌ Socket Connect Error: $data'));
      _socket?.onError((data) => print('❌ Socket Error: $data'));
      _socket?.onDisconnect((_) => print('🔌 Socket Disconnected'));

    } catch (e) {
      print('❌ Error initializing socket: $e');
    }
  }

  // Tham gia phòng chat của bài viết
  void joinPostRoom(String postId) {
    if (_socket == null) return;

    // Nếu đã connect thì join ngay
    if (_socket!.connected) {
      print('➡️ Emitting joinPost: $postId');
      _socket?.emit('joinPost', postId);
    } else {
      // Nếu chưa connect xong, đợi connect rồi mới join
      print('⏳ Socket not ready, waiting to join room...');
      _socket?.onConnect((_) {
        print('➡️ Emitting joinPost (delayed): $postId');
        _socket?.emit('joinPost', postId);
      });
    }
  }

  void leavePostRoom(String postId) {
    if (_socket != null) {
      print('⬅️ Leaving room: $postId');
      _socket?.emit('leavePost', postId);
    }
  }

  // Lắng nghe comment mới
  void onNewComment(Function(dynamic) callback) {
    _socket?.on('newComment', (data) {
      print('🔔 Socket received "newComment": $data');
      callback(data);
    });
  }

  void dispose() {
    print('🗑️ Disposing socket service');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}