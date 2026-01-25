class CommentModel {
  final String id;
  final String content;
  final String userId;
  final String userName;
  final String userAvatar;
  final DateTime createdAt;
  final int likeCount;
  final bool isLiked;

  CommentModel({
    required this.id,
    required this.content,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.createdAt,
    this.likeCount = 0,
    this.isLiked = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // Xử lý an toàn khi user là object hoặc population từ backend
    final userObj = json['author'] ?? {}; // Sửa 'user' thành 'author'
    
    return CommentModel(
      id: json['_id'] ?? json['id'] ?? '',
      content: json['content'] ?? '',
      userId: userObj['_id'] ?? userObj['id'] ?? json['authorId'] ?? '', // Sửa 'userId' thành 'authorId'
      userName: userObj['name'] ?? 'Unknown User',
      userAvatar: userObj['avatarUrl'] ?? 'https://i.pravatar.cc/150?u=default',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      likeCount: json['likes'] is List ? (json['likes'] as List).length : (json['likeCount'] ?? 0),
      isLiked: false, // Logic check like sẽ xử lý sau tùy backend
    );
  }

  // Helper để format thời gian (VD: 2h, 30m)
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo';
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}