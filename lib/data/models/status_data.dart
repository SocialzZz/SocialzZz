class StatusData {
  final String userName;
  final String userAvatar;
  final String postImage;
  final bool isVerified;
  final String likes;
  final String comments;
  final String shares;

  StatusData({
    required this.userName,
    required this.userAvatar,
    required this.postImage,
    this.isVerified = false,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}
