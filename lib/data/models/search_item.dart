/// Base model for search items
abstract class SearchItem {
  final String id;
  final String name;
  final String? subtitle;
  final String? imageUrl;

  SearchItem({
    required this.id,
    required this.name,
    this.subtitle,
    this.imageUrl,
  });
}

/// Account/User search item
class AccountItem extends SearchItem {
  final bool isFollowing;
  final String? category;

  AccountItem({
    required super.id,
    required super.name,
    this.isFollowing = false,
    this.category,
    super.imageUrl,
  }) : super(subtitle: category);

  AccountItem copyWith({
    String? id,
    String? name,
    bool? isFollowing,
    String? category,
    String? imageUrl,
  }) {
    return AccountItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isFollowing: isFollowing ?? this.isFollowing,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

/// Reel search item
class ReelItem extends SearchItem {
  final String? thumbnailUrl;
  final int? views;
  final String? authorId;

  ReelItem({
    required super.id,
    required super.name,
    this.thumbnailUrl,
    this.views,
    this.authorId,
    super.subtitle,
  }) : super(imageUrl: thumbnailUrl);
}

/// Place search item
class PlaceItem extends SearchItem {
  final String? address;
  final double? latitude;
  final double? longitude;

  PlaceItem({
    required super.id,
    required super.name,
    this.address,
    this.latitude,
    this.longitude,
  }) : super(subtitle: address);
}

/// Hashtag search item
class HashtagItem extends SearchItem {
  final int? postCount;

  HashtagItem({
    required super.id,
    required super.name,
    this.postCount,
  }) : super(
          subtitle: postCount != null ? '$postCount posts' : null,
        );
}

