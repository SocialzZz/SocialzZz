import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/search_item.dart';
import 'package:flutter_social_media_app/data/services/search_service.dart';
import 'search_header.dart';
import 'search_tabs.dart';
import 'account_list.dart';
import 'reel_list.dart';
import 'place_list.dart';
import 'hashtag_list.dart';

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

  final Color _accent = const Color(0xFFFF6B35);
  final Color _textPrimary = const Color(0xFF212121);
  final Color _textSecondary = const Color(0xFF757575);
  final Color _divider = const Color(0xFFE0E0E0);

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
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SearchHeader(
              searchController: _searchController,
              searchQuery: _searchQuery,
              onClearSearch: _clearSearch,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SearchTabs(
                selectedTab: _selectedTab,
                accentColor: _accent,
                textSecondaryColor: _textSecondary,
                onTabChanged: _onTabChanged,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildContent()),
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
        return AccountList(
          accounts: _accounts,
          accentColor: _accent,
          textPrimaryColor: _textPrimary,
          textSecondaryColor: _textSecondary,
          dividerColor: _divider,
          onToggleFollow: _toggleFollow,
        );
      case 1:
        return ReelList(
          reels: _reels,
          accentColor: _accent,
          textPrimaryColor: _textPrimary,
          textSecondaryColor: _textSecondary,
          dividerColor: _divider,
        );
      case 2:
        return PlaceList(
          places: _places,
          accentColor: _accent,
          textPrimaryColor: _textPrimary,
          textSecondaryColor: _textSecondary,
          dividerColor: _divider,
        );
      case 3:
        return HashtagList(
          hashtags: _hashtags,
          accentColor: _accent,
          textPrimaryColor: _textPrimary,
          textSecondaryColor: _textSecondary,
          dividerColor: _divider,
        );
      default:
        return const SizedBox();
    }
  }
}
