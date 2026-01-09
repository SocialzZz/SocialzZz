class LiveCardData {
  final String backgroundImageURL;
  final String avatarURL;
  final String userName;
  final bool isYou;

  LiveCardData({
    required this.backgroundImageURL,
    required this.avatarURL,
    required this.userName,
    this.isYou = false,
  });
}
