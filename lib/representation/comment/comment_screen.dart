import 'package:flutter/material.dart';
import '../../data/models/comment_data.dart';
import 'comment_item.dart';

class CommentScreen extends StatefulWidget {
  final String postOwnerName;
  final String postOwnerAvatar;
  final String postCaption;
  final String postTime;

  const CommentScreen({
    super.key,
    this.postOwnerName = 'Brooklyn Simmons',
    this.postOwnerAvatar = 'https://i.pravatar.cc/150?img=1',
    this.postCaption = 'Amazing sunset view from my balcony! 🌅 #sunset #vibes',
    this.postTime = '2 hours ago',
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final Color primaryColor = const Color(0xFFF9622E);
  final TextEditingController _commentController = TextEditingController();
  final List<CommentData> _comments = CommentData.getMockData();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  int get _totalComments => _comments.fold(0, (sum, c) => sum + 1 + c.totalReplies);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [_buildHeader(), Expanded(child: _buildCommentContainer())],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            ),
          ),
          const Expanded(child: Text('Comments', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600))),
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.more_vert, color: Colors.black, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPostInfo(),
                const SizedBox(height: 16),
                Text('$_totalComments comments', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                ..._comments.map((c) => CommentItem(comment: c)),
              ],
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildPostInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 22, backgroundImage: NetworkImage(widget.postOwnerAvatar)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(widget.postOwnerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(width: 4),
                  Icon(Icons.verified, color: primaryColor, size: 16),
                ]),
                const SizedBox(height: 4),
                Text(widget.postCaption, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 6),
                Text(widget.postTime, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
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
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))]),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.add, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const CircleAvatar(radius: 16, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=25')),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _commentController, decoration: InputDecoration(hintText: 'Write a comment...', hintStyle: TextStyle(color: Colors.grey[400]), border: InputBorder.none))),
            GestureDetector(
              onTap: () => _commentController.clear(),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
