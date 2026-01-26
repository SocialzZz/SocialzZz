// lib/representation/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/services/post_service.dart';
import 'package:flutter_social_media_app/data/models/post_model.dart';
import 'package:flutter_social_media_app/widgets/post_skeleton.dart';
import '../../data/models/live_card_data.dart';
import 'home_header.dart';
import 'live_card_widget.dart';
import 'status_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();
  final ScrollController _scrollController = ScrollController();

  // GIỮ NGUYÊN Live Cards
  final List<LiveCardData> _liveItems = [
    LiveCardData(
      backgroundImageURL: 'assets/images/connect.svg',
      avatarURL: 'assets/images/profile.svg',
      userName: 'You',
      isYou: true,
    ),
    LiveCardData(
      backgroundImageURL: 'assets/images/profile.svg',
      avatarURL: 'assets/images/connect.svg',
      userName: 'Theresa',
    ),
    LiveCardData(
      backgroundImageURL: 'assets/images/video.svg',
      avatarURL: 'assets/images/welcome.svg',
      userName: 'James Scob',
    ),
    LiveCardData(
      backgroundImageURL: 'assets/images/welcome.svg',
      avatarURL: 'assets/images/video.svg',
      userName: 'James ',
    ),
  ];

  List<PostModel> _posts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _postsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // PHÁT HIỆN KHI SCROLL ĐẾN CUỐI
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMorePosts();
    }
  }

  // TẢI POSTS LẦN ĐẦU
  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _posts = [];
      _hasMore = true;
    });

    try {
      final posts = await _postService.getPosts(
        page: _currentPage,
        limit: _postsPerPage,
      );

      setState(() {
        _posts = posts;
        _isLoading = false;
        _hasMore = posts.length >= _postsPerPage;
      });

      print('✅ Loaded ${posts.length} posts (page $_currentPage)');
    } catch (e) {
      print('❌ Error loading posts: $e');
      setState(() {
        _isLoading = false;
        _posts = [];
        _hasMore = false;
      });
    }
  }

  // TẢI THÊM POSTS KHI SCROLL
  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;
      final newPosts = await _postService.getPosts(
        page: _currentPage,
        limit: _postsPerPage,
      );

      setState(() {
        _posts.addAll(newPosts);
        _isLoadingMore = false;
        _hasMore = newPosts.length >= _postsPerPage;
      });

      print('✅ Loaded ${newPosts.length} more posts (page $_currentPage)');
    } catch (e) {
      print('❌ Error loading more posts: $e');
      setState(() {
        _isLoadingMore = false;
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        onRefresh: _loadPosts,
        color: const Color(0xFFF9622E),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header
            const SliverToBoxAdapter(child: HomeHeader()),

            // Live Cards
            SliverToBoxAdapter(
              child: Padding(
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
              ),
            ),

            // ⭐ SKELETON LOADING
            if (_isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const PostSkeleton(),
                  childCount: 3, // Hiển thị 3 skeleton
                ),
              ),

            // ⭐ POSTS LIST
            if (!_isLoading && _posts.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.post_add, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No posts yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create your first post!',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

            if (!_isLoading && _posts.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return StatusCardWidget(post: _posts[index]);
                }, childCount: _posts.length),
              ),

            // ⭐ LOADING MORE INDICATOR
            if (_isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFF9622E)),
                  ),
                ),
              ),

            // ⭐ END OF LIST MESSAGE
            if (!_isLoading && !_hasMore && _posts.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'You\'ve reached the end ',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
