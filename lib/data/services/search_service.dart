import '../models/search_item.dart';

/// Service interface for search functionality
abstract class SearchService {
  Future<List<AccountItem>> searchAccounts(String query);
  Future<List<ReelItem>> searchReels(String query);
  Future<List<PlaceItem>> searchPlaces(String query);
  Future<List<HashtagItem>> searchHashtags(String query);
  
  Future<void> followAccount(String accountId);
  Future<void> unfollowAccount(String accountId);
}

/// Mock implementation 
class MockSearchService implements SearchService {
  // Mock data
  final List<AccountItem> _mockAccounts = [
    AccountItem(
      id: '1',
      name: 'carla_choen',
      category: 'Fashion',
      isFollowing: false,
    ),
    AccountItem(
      id: '2',
      name: 'Carla_mCoy',
      category: 'Fashion',
      isFollowing: false,
    ),
    AccountItem(
      id: '3',
      name: 'Carla_bell',
      category: 'Artist',
      isFollowing: true,
    ),
    AccountItem(
      id: '4',
      name: 'Carla_watson',
      category: 'Business',
      isFollowing: true,
    ),
    AccountItem(
      id: '5',
      name: 'Carla_miles',
      category: 'Fashion',
      isFollowing: false,
    ),
    AccountItem(
      id: '6',
      name: 'Carlanah_nguyen',
      category: 'Business',
      isFollowing: true,
    ),
    AccountItem(
      id: '7',
      name: 'Carlatin_watson',
      category: 'Fashion',
      isFollowing: false,
    ),
    AccountItem(
      id: '8',
      name: 'Carla_fisher',
      category: 'Business',
      isFollowing: true,
    ),
    AccountItem(
      id: '9',
      name: 'kristin_watson',
      category: 'Fashion',
      isFollowing: true,
    ),
  ];

  final List<ReelItem> _mockReels = [
    ReelItem(
      id: 'r1',
      name: 'Fashion Trends 2024',
      views: 125000,
      authorId: '1',
    ),
    ReelItem(
      id: 'r2',
      name: 'Art Showcase',
      views: 89000,
      authorId: '3',
    ),
    ReelItem(
      id: 'r3',
      name: 'Business Tips',
      views: 156000,
      authorId: '4',
    ),
  ];

  final List<PlaceItem> _mockPlaces = [
    PlaceItem(
      id: 'p1',
      name: 'New York Fashion District',
      address: 'New York, NY',
    ),
    PlaceItem(
      id: 'p2',
      name: 'Los Angeles Art Gallery',
      address: 'Los Angeles, CA',
    ),
    PlaceItem(
      id: 'p3',
      name: 'San Francisco Business Center',
      address: 'San Francisco, CA',
    ),
  ];

  final List<HashtagItem> _mockHashtags = [
    HashtagItem(
      id: 'h1',
      name: 'fashion',
      postCount: 1250000,
    ),
    HashtagItem(
      id: 'h2',
      name: 'art',
      postCount: 890000,
    ),
    HashtagItem(
      id: 'h3',
      name: 'business',
      postCount: 560000,
    ),
  ];

  @override
  Future<List<AccountItem>> searchAccounts(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return _mockAccounts;
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockAccounts
        .where((account) =>
            account.name.toLowerCase().contains(lowerQuery) ||
            (account.category?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  @override
  Future<List<ReelItem>> searchReels(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return _mockReels;
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockReels
        .where((reel) => reel.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<List<PlaceItem>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return _mockPlaces;
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockPlaces
        .where((place) =>
            place.name.toLowerCase().contains(lowerQuery) ||
            (place.address?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  @override
  Future<List<HashtagItem>> searchHashtags(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return _mockHashtags;
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockHashtags
        .where((hashtag) => hashtag.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<void> followAccount(String accountId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _mockAccounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      _mockAccounts[index] = _mockAccounts[index].copyWith(isFollowing: true);
    }
  }

  @override
  Future<void> unfollowAccount(String accountId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _mockAccounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      _mockAccounts[index] = _mockAccounts[index].copyWith(isFollowing: false);
    }
  }
}

