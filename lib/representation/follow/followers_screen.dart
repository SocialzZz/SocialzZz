import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/follow_item.dart';
import 'package:flutter_social_media_app/data/services/follow_service.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  final FollowService _followService = MockFollowService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  int _selectedSegment = 0; // 0 = Followers, 1 = Following
  String _searchQuery = '';
  bool _isLoading = false;

  List<FollowItem> _followers = [];
  List<FollowItem> _following = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchQuery != query) {
        setState(() {
          _searchQuery = query;
        });
        _performSearch();
      }
    });
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _loadFollowers(),
        _loadFollowing(),
      ]);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadFollowers() async {
    try {
      final followers = await _followService.getFollowers('current_user');
      if (mounted) {
        setState(() {
          _followers = followers;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải followers: $e')),
        );
      }
    }
  }

  Future<void> _loadFollowing() async {
    try {
      final following = await _followService.getFollowing('current_user');
      if (mounted) {
        setState(() {
          _following = following;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải following: $e')),
        );
      }
    }
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedSegment == 0) {
        _followers = await _followService.searchFollowers('current_user', _searchQuery);
      } else {
        _following = await _followService.searchFollowing('current_user', _searchQuery);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tìm kiếm: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSegmentChanged(int index) {
    if (_selectedSegment != index) {
      setState(() {
        _selectedSegment = index;
      });
      _performSearch();
    }
  }

  Future<void> _toggleFollow(FollowItem item) async {
    // Optimistic update
    setState(() {
      if (_selectedSegment == 0) {
        final index = _followers.indexWhere((f) => f.id == item.id);
        if (index != -1) {
          _followers[index] = item.copyWith(isFollowing: !item.isFollowing);
        }
      } else {
        final index = _following.indexWhere((f) => f.id == item.id);
        if (index != -1) {
          _following[index] = item.copyWith(isFollowing: !item.isFollowing);
        }
      }
    });

    try {
      if (item.isFollowing) {
        await _followService.unfollowUser(item.id);
      } else {
        await _followService.followUser(item.id);
      }
      
      // Reload data to sync
      if (_selectedSegment == 0) {
        await _loadFollowers();
      } else {
        await _loadFollowing();
      }
    } catch (e) {
      // Rollback on error
      setState(() {
        if (_selectedSegment == 0) {
          final index = _followers.indexWhere((f) => f.id == item.id);
          if (index != -1) {
            _followers[index] = item;
          }
        } else {
          final index = _following.indexWhere((f) => f.id == item.id);
          if (index != -1) {
            _following[index] = item;
          }
        }
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  final Color _accent = const Color(0xFFFF6B35);
  final Color _textPrimary = const Color(0xFF212121);
  final Color _textSecondary = const Color(0xFF757575);
  final Color _bgLight = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _selectedSegment == 0 ? 'Followers' : 'Following',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Segmented Control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: _buildSegmentedControl(),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 8),
          // Content List
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      decoration: BoxDecoration(
        color: _bgLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              label: 'Followers',
              isSelected: _selectedSegment == 0,
              onTap: () => _onSegmentChanged(0),
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              label: 'Following',
              isSelected: _selectedSegment == 1,
              onTap: () => _onSegmentChanged(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? _accent : _textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: _bgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: _textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: _selectedSegment == 0
              ? 'Search followers...'
              : 'Search following...',
          hintStyle: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9E9E9E),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
        ),
      );
    }

    final items = _selectedSegment == 0 ? _followers : _following;

    if (items.isEmpty) {
      return Center(
        child: Text(
          _selectedSegment == 0
              ? 'No followers found'
              : 'No following found',
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildUserItem(item);
      },
    );
  }

  Widget _buildUserItem(FollowItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _bgLight,
              shape: BoxShape.circle,
            ),
            child: item.imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      item.imageUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 28,
                          color: _accent.withOpacity(0.6),
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 28,
                    color: _accent.withOpacity(0.6),
                  ),
          ),
          const SizedBox(width: 12),
          // Name and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Follow/Following Button
          _FollowButton(
            isFollowing: item.isFollowing,
            accent: _accent,
            onTap: () => _toggleFollow(item),
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.isFollowing,
    required this.accent,
    this.onTap,
  });

  final bool isFollowing;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isFollowing ? Colors.white : accent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accent,
            width: 1.5,
          ),
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            color: isFollowing ? accent : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
