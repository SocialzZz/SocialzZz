// lib/representation/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/services/post_service.dart';
import 'package:flutter_social_media_app/data/models/post_model.dart';
import '../../data/models/live_card_data.dart';
import 'home_header.dart';
import 'live_card_widget.dart';
import 'status_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();

  // GIỮ NGUYÊN Live Cards
  final List<LiveCardData> _liveItems = [
    LiveCardData(
      backgroundImageURL: 'assets/images/i.jpg',
      avatarURL: 'assets/images/avt.png',
      userName: 'You',
      isYou: true,
    ),
    LiveCardData(
      backgroundImageURL: 'assets/images/i.jpg',
      avatarURL: 'assets/images/avt.png',
      userName: 'Theresa',
    ),
    LiveCardData(
      backgroundImageURL: 'assets/images/i.jpg',
      avatarURL: 'assets/images/avt.png',
      userName: 'James Scob',
    ),
  ];

  List<PostModel> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _postService.getPosts(page: 1, limit: 20);

      setState(() {
        _posts = posts;
        _isLoading = false;
      });

      print('✅ Loaded ${posts.length} posts');
    } catch (e) {
      print('❌ Error loading posts: $e');
      setState(() {
        _isLoading = false;
        _posts = []; // Empty list nếu lỗi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị loading khi đang tải
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF9622E)),
      );
    }

    // Hiển thị message nếu không có posts
    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.post_add, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No posts yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first post!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        onRefresh: _loadPosts,
        child: ListView.builder(
          itemCount: _posts.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const HomeHeader();
            } else if (index == 1) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _liveItems.length,
                    itemBuilder: (context, i) =>
                        LiveCardWidget(data: _liveItems[i]),
                  ),
                ),
              );
            } else {
              // TRUYỀN PostModel trực tiếp vào StatusCardWidget
              return StatusCardWidget(post: _posts[index - 2]);
            }
          },
        ),
      ),
    );
  }
}
