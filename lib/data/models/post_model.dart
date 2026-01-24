// lib/data/models/post_model.dart
class PostAuthor {
  final String id;
  final String? name;
  final String? avatarUrl;

  PostAuthor({required this.id, this.name, this.avatarUrl});

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

class PostCounts {
  final int comments;
  final int reactions;

  PostCounts({required this.comments, required this.reactions});

  factory PostCounts.fromJson(Map<String, dynamic> json) {
    return PostCounts(
      comments: json['comments'] ?? 0,
      reactions: json['reactions'] ?? 0,
    );
  }
}

class PostModel {
  final String id;
  final String content;
  final String authorId;
  final DateTime createdAt;
  final List<String>? mediaUrls;
  final String privacy;
  final String? feeling;
  final String? location;
  final List<String> hashtags;
  final PostAuthor author;
  final PostCounts counts;

  PostModel({
    required this.id,
    required this.content,
    required this.authorId,
    required this.createdAt,
    required this.mediaUrls,
    required this.privacy,
    this.feeling,
    this.location,
    required this.hashtags,
    required this.author,
    required this.counts,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      authorId: json['authorId'],
      createdAt: DateTime.parse(json['createdAt']),
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      privacy: json['privacy'],
      feeling: json['feeling'],
      location: json['location'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      author: PostAuthor.fromJson(json['author']),
      counts: PostCounts.fromJson(json['_count']),
    );
  }

  // ⭐ Getter để sử dụng trực tiếp trong UI
  String get userName => author.name ?? 'Unknown User';

  String get userAvatar {
    // Nếu có avatarUrl từ API, dùng network image
    // Nếu không, dùng placeholder asset
    return author.avatarUrl ?? 'assets/images/avt.png';
  }

  String get postImage {
    // Ưu tiên ảnh đầu tiên trong mediaUrls
    // Nếu không có, dùng placeholder
    if (mediaUrls != null && mediaUrls!.isNotEmpty) {
      return mediaUrls!.first;
    }
    return '';
  }

  bool get isVerified => false; // Backend chưa có field này, default false

  String get likes => _formatCount(counts.reactions);

  String get comments => _formatCount(counts.comments);

  String get shares => '0'; // Backend chưa có shares

  // Helper: Format số thành k, M
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return count.toString();
    }
  }
}
