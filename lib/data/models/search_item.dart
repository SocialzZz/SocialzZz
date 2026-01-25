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
  final bool requestSent;
  final bool requestReceived;
  final bool isFriend;
  final String? category;

  AccountItem({
    required String id,
    required String name,
    this.isFollowing = false,
    this.requestSent = false,
    this.requestReceived = false,
    this.isFriend = false,
    this.category,
    String? imageUrl,
  }) : super(
    id: id,
    name: name,
    subtitle: category,
    imageUrl: imageUrl,
  );

  AccountItem copyWith({
    String? id,
    String? name,
    bool? isFollowing,
    bool? requestSent,
    bool? requestReceived,
    bool? isFriend,
    String? category,
    String? imageUrl,
  }) {
    return AccountItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isFollowing: isFollowing ?? this.isFollowing,
      requestSent: requestSent ?? this.requestSent,
      requestReceived: requestReceived ?? this.requestReceived,
      isFriend: isFriend ?? this.isFriend,
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
    required String id,
    required String name,
    this.thumbnailUrl,
    this.views,
    this.authorId,
    String? subtitle,
  }) : super(
    id: id,
    name: name,
    subtitle: subtitle,
    imageUrl: thumbnailUrl,
  );
}

/// Place search item
class PlaceItem extends SearchItem {
  final String? address;
  final double? latitude;
  final double? longitude;

  PlaceItem({
    required String id,
    required String name,
    this.address,
    this.latitude,
    this.longitude,
  }) : super(
    id: id,
    name: name,
    subtitle: address,
  );
}

/// Hashtag search item
class HashtagItem extends SearchItem {
  final int? postCount;

  HashtagItem({
    required String id,
    required String name,
    this.postCount,
  }) : super(
    id: id,
    name: name,
    subtitle: postCount != null ? '$postCount posts' : null,
  );
}