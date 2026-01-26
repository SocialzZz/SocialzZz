// lib/representation/search/search_screen.dart
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
  final SearchService _searchService = RealSearchService();
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
    // ⭐ TẢI SUGGESTIONS KHI MỚI VÀO TRANG
    _loadInitialSuggestions();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // ⭐ HÀM TẢI GỢI Ý BAN ĐẦU
  Future<void> _loadInitialSuggestions() async {
    setState(() => _isLoading = true);

    try {
      // Tải suggestions cho accounts (tab đầu tiên)
      _accounts = await _searchService.getSuggestedAccounts();

      print('✅ Loaded ${_accounts.length} suggested accounts');
    } catch (e) {
      print('❌ Error loading suggestions: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  Future<void> _performSearch() async {
    // ⭐ NẾU XÓA HẾT TEXT, TẢI LẠI SUGGESTIONS
    if (_searchQuery.isEmpty) {
      _loadInitialSuggestions();
      return;
    }

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
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
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

      // ⭐ NẾU CHƯA CÓ SEARCH QUERY, TẢI SUGGESTIONS
      if (_searchQuery.isEmpty && index == 0) {
        _loadInitialSuggestions();
      } else {
        _performSearch();
      }
    }
  }

  Future<void> _toggleFollow(AccountItem account) async {
    if (account.requestSent) {
      await _cancelRequest(account);
      return;
    }

    // If already friend, do nothing
    if (account.isFriend) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💥 Already friends'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Optimistic update
    setState(() {
      final index = _accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        _accounts[index] = account.copyWith(requestSent: true);
      }
    });

    try {
      // Send friend request
      await _searchService.followAccount(account.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Request sent!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Rollback on error
      setState(() {
        final index = _accounts.indexWhere((a) => a.id == account.id);
        if (index != -1) {
          _accounts[index] = account.copyWith(requestSent: false);
        }
      });

      if (mounted) {
        String errorMsg = e.toString().replaceAll('Exception: ', '');

        // If "already exists" error, still keep requestSent as true
        if (errorMsg.contains('already exists')) {
          setState(() {
            final index = _accounts.indexWhere((a) => a.id == account.id);
            if (index != -1) {
              _accounts[index] = account.copyWith(requestSent: true);
            }
          });
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ $errorMsg'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _cancelRequest(AccountItem account) async {
    // Optimistic update
    setState(() {
      final index = _accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        _accounts[index] = account.copyWith(requestSent: false);
      }
    });

    try {
      await _searchService.cancelRequest(account.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Request canceled'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Rollback on error
      setState(() {
        final index = _accounts.indexWhere((a) => a.id == account.id);
        if (index != -1) {
          _accounts[index] = account.copyWith(requestSent: true);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    // ⭐ TẢI LẠI SUGGESTIONS SAU KHI XÓA
    _loadInitialSuggestions();
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
        if (_accounts.isEmpty && _searchQuery.isNotEmpty) {
          return const Center(child: Text('No accounts found'));
        }
        if (_accounts.isEmpty) {
          return const Center(
            child: Text(
              'Loading suggestions...',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
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
