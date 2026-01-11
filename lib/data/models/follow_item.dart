/// Model for follower/following user
class FollowItem {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool isFollowing;

  FollowItem({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.isFollowing = false,
  });

  FollowItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isFollowing,
  }) {
    return FollowItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
