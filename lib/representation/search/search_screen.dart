import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/search_item.dart';
import 'package:flutter_social_media_app/data/services/search_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _searchService = MockSearchService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  int _selectedTab = 0;
  String _searchQuery = '';
  bool _isLoading = false;

  // State cho từng tab
  List<AccountItem> _accounts = [];
  List<ReelItem> _reels = [];
  List<PlaceItem> _places = [];
  List<HashtagItem> _hashtags = [];

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
    
    // Debounce search 
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
      await _performSearch();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      switch (_selectedTab) {
        case 0: // Account
          _accounts = await _searchService.searchAccounts(_searchQuery);
          break;
        case 1: // Reel
          _reels = await _searchService.searchReels(_searchQuery);
          break;
        case 2: // Place
          _places = await _searchService.searchPlaces(_searchQuery);
          break;
        case 3: // Hashtag
          _hashtags = await _searchService.searchHashtags(_searchQuery);
          break;
      }
    } catch (e) {
      // Handle error - có thể show snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
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

  void _onTabChanged(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      _performSearch();
    }
  }

  Future<void> _toggleFollow(AccountItem account) async {
    // Optimistic update
    setState(() {
      final index = _accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        _accounts[index] = account.copyWith(isFollowing: !account.isFollowing);
      }
    });

    try {
      if (account.isFollowing) {
        await _searchService.unfollowAccount(account.id);
      } else {
        await _searchService.followAccount(account.id);
      }
    } catch (e) {
      // Rollback on error
      setState(() {
        final index = _accounts.indexWhere((a) => a.id == account.id);
        if (index != -1) {
          _accounts[index] = account;
        }
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _performSearch();
  }

  final Color _accent = const Color(0xFFFF6B35);
  final Color _textPrimary = const Color(0xFF212121);
  final Color _textSecondary = const Color(0xFF757575);
  final Color _divider = const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Color(0xFF9E9E9E)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9E9E9E),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: _clearSearch,
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFF9E9E9E),
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildTabs(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildContent(),
            ),
          ],
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

    switch (_selectedTab) {
      case 0:
        return _buildAccountList();
      case 1:
        return _buildReelList();
      case 2:
        return _buildPlaceList();
      case 3:
        return _buildHashtagList();
      default:
        return const SizedBox();
    }
  }

  Widget _buildAccountList() {
    if (_accounts.isEmpty) {
      return const Center(
        child: Text(
          'No accounts found',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      itemCount: _accounts.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: _divider),
      itemBuilder: (context, index) {
        final account = _accounts[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _AvatarPlaceholder(accent: _accent, imageUrl: account.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    if (account.category != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        account.category!,
                        style: TextStyle(
                          fontSize: 13,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _FollowButton(
                isFollowing: account.isFollowing,
                accent: _accent,
                onTap: () => _toggleFollow(account),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReelList() {
    if (_reels.isEmpty) {
      return const Center(
        child: Text(
          'No reels found',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      itemCount: _reels.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: _divider),
      itemBuilder: (context, index) {
        final reel = _reels[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _AvatarPlaceholder(accent: _accent, imageUrl: reel.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reel.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    if (reel.views != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${_formatViews(reel.views!)} views',
                        style: TextStyle(
                          fontSize: 13,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceList() {
    if (_places.isEmpty) {
      return const Center(
        child: Text(
          'No places found',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      itemCount: _places.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: _divider),
      itemBuilder: (context, index) {
        final place = _places[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _AvatarPlaceholder(accent: _accent, imageUrl: place.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    if (place.address != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        place.address!,
                        style: TextStyle(
                          fontSize: 13,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHashtagList() {
    if (_hashtags.isEmpty) {
      return const Center(
        child: Text(
          'No hashtags found',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      itemCount: _hashtags.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: _divider),
      itemBuilder: (context, index) {
        final hashtag = _hashtags[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _AvatarPlaceholder(accent: _accent, imageUrl: hashtag.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${hashtag.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    if (hashtag.postCount != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        hashtag.subtitle ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }

  Widget _buildTabs() {
    final tabs = [
      (icon: Icons.person_outline, label: 'Account'),
      (icon: Icons.live_tv, label: 'Reel'),
      (icon: Icons.place_outlined, label: 'Place'),
      (icon: Icons.tag, label: 'Hashtag'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(tabs.length, (index) {
        final isActive = _selectedTab == index;
        return Expanded(
          child: InkWell(
            onTap: () => _onTabChanged(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[index].icon,
                      size: 18,
                      color: isActive ? _accent : _textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tabs[index].label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? _accent : _textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: 42,
                  decoration: BoxDecoration(
                    color: isActive ? _accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
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
      child: isFollowing
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: accent, width: 1.4),
                color: Colors.white,
              ),
              child: Text(
                'Following',
                style: TextStyle(
                  color: accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Follow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({
    required this.accent,
    this.imageUrl,
  });

  final Color accent;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFFF3F4F6),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Icon(
              Icons.landscape,
              size: 20,
              color: accent.withOpacity(0.6),
            )
          : null,
    );
  }
}
