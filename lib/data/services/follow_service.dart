import '../models/follow_item.dart';

/// Service interface for followers/following functionality
abstract class FollowService {
  Future<List<FollowItem>> getFollowers(String userId);
  Future<List<FollowItem>> getFollowing(String userId);
  Future<List<FollowItem>> searchFollowers(String userId, String query);
  Future<List<FollowItem>> searchFollowing(String userId, String query);
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
}

/// Mock implementation
class MockFollowService implements FollowService {
  // Mock followers data
  final List<FollowItem> _mockFollowers = [
    FollowItem(
      id: '1',
      name: 'William Smith',
      description: 'Sports News & Media',
      isFollowing: true,
    ),
    FollowItem(
      id: '2',
      name: 'Sarah Johnson',
      description: 'Creative Director',
      isFollowing: false,
    ),
    FollowItem(
      id: '3',
      name: 'John Doe',
      description: 'Software Engineer',
      isFollowing: false,
    ),
    FollowItem(
      id: '4',
      name: 'Emily White',
      description: 'Product Designer',
      isFollowing: true,
    ),
    FollowItem(
      id: '5',
      name: 'Jessica Green',
      description: 'UX Researcher',
      isFollowing: false,
    ),
    FollowItem(
      id: '6',
      name: 'David Lee',
      description: 'Data Scientist',
      isFollowing: true,
    ),
    FollowItem(
      id: '7',
      name: 'Michael Chen',
      description: 'Marketing Manager',
      isFollowing: false,
    ),
    FollowItem(
      id: '8',
      name: 'Lisa Wang',
      description: 'Content Creator',
      isFollowing: true,
    ),
  ];

  // Mock following data
  final List<FollowItem> _mockFollowing = [
    FollowItem(
      id: '1',
      name: 'Emily Davis',
      description: 'Product Manager',
      isFollowing: true,
    ),
    FollowItem(
      id: '2',
      name: 'Michael Brown',
      description: 'Software Engineer',
      isFollowing: true,
    ),
    FollowItem(
      id: '3',
      name: 'Sophia Miller',
      description: 'UX Designer',
      isFollowing: true,
    ),
    FollowItem(
      id: '4',
      name: 'David Wilson',
      description: 'Marketing Specialist',
      isFollowing: true,
    ),
    FollowItem(
      id: '5',
      name: 'Olivia Moore',
      description: 'Data Scientist',
      isFollowing: true,
    ),
    FollowItem(
      id: '6',
      name: 'James Taylor',
      description: 'Cloud Architect',
      isFollowing: true,
    ),
    FollowItem(
      id: '7',
      name: 'Emma Anderson',
      description: 'Graphic Designer',
      isFollowing: true,
    ),
    FollowItem(
      id: '8',
      name: 'Noah Martinez',
      description: 'Business Analyst',
      isFollowing: true,
    ),
  ];

  @override
  Future<List<FollowItem>> getFollowers(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockFollowers);
  }

  @override
  Future<List<FollowItem>> getFollowing(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockFollowing);
  }

  @override
  Future<List<FollowItem>> searchFollowers(String userId, String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return List.from(_mockFollowers);
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockFollowers
        .where((follower) =>
            follower.name.toLowerCase().contains(lowerQuery) ||
            (follower.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  @override
  Future<List<FollowItem>> searchFollowing(String userId, String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return List.from(_mockFollowing);
    }
    
    final lowerQuery = query.toLowerCase();
    return _mockFollowing
        .where((following) =>
            following.name.toLowerCase().contains(lowerQuery) ||
            (following.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  @override
  Future<void> followUser(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _mockFollowers.indexWhere((follower) => follower.id == userId);
    if (index != -1) {
      _mockFollowers[index] = _mockFollowers[index].copyWith(isFollowing: true);
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _mockFollowers.indexWhere((follower) => follower.id == userId);
    if (index != -1) {
      _mockFollowers[index] = _mockFollowers[index].copyWith(isFollowing: false);
    }
    
    final followingIndex = _mockFollowing.indexWhere((following) => following.id == userId);
    if (followingIndex != -1) {
      _mockFollowing[followingIndex] = _mockFollowing[followingIndex].copyWith(isFollowing: false);
    }
  }
}
