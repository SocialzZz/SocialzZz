import 'dart:convert'; // Import để dùng jsonDecode
import 'package:flutter/material.dart';
import '../../data/models/comment_model.dart';
import '../../data/services/post_service.dart';
import '../../data/services/socket_service.dart';
import './comment_item.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final String postOwnerAvatar;
  final String postCaption;

  const CommentScreen({
    super.key,
    required this.postId,
    this.postOwnerAvatar = 'https://i.pravatar.cc/150?img=1',
    this.postCaption = '',
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final Color primaryColor = const Color(0xFFF9622E);

  final TextEditingController _commentController = TextEditingController();
  final PostService _postService = PostService();
  final SocketService _socketService = SocketService();

  List<CommentModel> _comments = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    // 1. Kết nối Socket trước hoặc song song
    await _setupSocket();

    // 2. Load API
    await _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final comments = await _postService.getComments(widget.postId);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading comments: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _setupSocket() async {
    await _socketService.connect();

    // Join room ngay lập tức (SocketService mới đã tự xử lý đợi connect)
    _socketService.joinPostRoom(widget.postId);

    _socketService.onNewComment((data) {
      if (!mounted) return;

      try {
        print("🔔 Processing socket data...");

        // 1. Xử lý nếu data là String (JSON String)
        dynamic processedData = data;
        if (data is String) {
          processedData = jsonDecode(data);
        }

        // 2. Map dữ liệu author -> user (nếu cần)
        if (processedData is Map<String, dynamic>) {
          if (processedData.containsKey('author') &&
              !processedData.containsKey('user')) {
            processedData['user'] = processedData['author'];
          }
        } else {
          print("⚠️ Socket data is not a Map: $processedData");
          return;
        }

        // 3. Convert sang Model
        final newComment = CommentModel.fromJson(processedData);

        // 4. Update UI (Kiểm tra trùng lặp)
        setState(() {
          final exists = _comments.any((c) => c.id == newComment.id);
          if (!exists) {
            _comments.insert(0, newComment);
            print("✅ Added new comment from socket to UI");
          } else {
            print("ℹ️ Comment already exists in list (skipped)");
          }
        });
      } catch (e) {
        print("❌ Error parsing/adding socket comment: $e");
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _socketService.leavePostRoom(widget.postId);
    _socketService.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);

    try {
      print("📤 Sending comment: $text");
      // Gọi API
      final newComment = await _postService.addComment(widget.postId, text);

      print("✅ API Success. New Comment ID: ${newComment.id}");

      if (mounted) {
        setState(() {
          // Thêm ngay vào list để người gửi thấy liền (Optimistic update)
          // Socket có thể gửi lại event này, nhưng logic check trùng ID ở trên sẽ lo việc đó.
          _comments.insert(0, newComment);
          _commentController.clear();
          _isSending = false;
        });
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      print("❌ Failed to send comment: $e");
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(
                                top: 16,
                                bottom: 16,
                              ),
                              itemCount: _comments.isEmpty
                                  ? 1
                                  : _comments.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) return _buildCaptionHeader();
                                if (_comments.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Center(
                                      child: Text(
                                        "No comments yet. Be the first!",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  );
                                }
                                return CommentItem(
                                  comment: _comments[index - 1],
                                );
                              },
                            ),
                    ),
                    _buildInputBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60, // Chiều cao header
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Nút Back theo vị trí yêu cầu
          Positioned(
            left: 0, // left: 17px (tính tương đối từ padding cha 16 + 1 ~ 17)
            top: 25, // top: 20px (tính tương đối)
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white, // Nền trắng cho nút back
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ),

          // Title ở giữa
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Comments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Nút More (Option) bên phải
          Positioned(
            right: 0,
            top: 25,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.more_vert, color: Colors.black, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptionHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.postOwnerAvatar),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Post Author",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.postCaption,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: _isSending ? null : _sendComment,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: _isSending
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
