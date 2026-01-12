class CommentData {
  final String id;
  final String name;
  final String avatar;
  final String text;
  final String time;
  final int likes;
  final bool isLiked;
  final List<CommentData> replies;

  CommentData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.text,
    required this.time,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
  });

  static List<CommentData> getMockData() {
    return [
      CommentData(
        id: '1',
        name: 'Jane Cooper',
        avatar: 'https://i.pravatar.cc/150?img=10',
        text: 'Great post! This is absolutely stunning 🔥',
        time: '2m',
        likes: 12,
        replies: [
          CommentData(id: '1-1', name: 'John Doe', avatar: 'https://i.pravatar.cc/150?img=11', text: 'Totally agree!', time: '1m', likes: 2),
        ],
      ),
      CommentData(
        id: '2',
        name: 'Mike Smith',
        avatar: 'https://i.pravatar.cc/150?img=12',
        text: 'Amazing content as always 👏',
        time: '5m',
        likes: 8,
        isLiked: true,
      ),
      CommentData(
        id: '3',
        name: 'Sarah Wilson',
        avatar: 'https://i.pravatar.cc/150?img=13',
        text: 'Where is this place? I need to visit! 😍',
        time: '10m',
        likes: 5,
        replies: [
          CommentData(id: '3-1', name: 'Brooklyn Simmons', avatar: 'https://i.pravatar.cc/150?img=1', text: "It's in Bali! You should definitely go 🌴", time: '8m', likes: 3),
          CommentData(id: '3-2', name: 'Sarah Wilson', avatar: 'https://i.pravatar.cc/150?img=13', text: 'Thanks! Adding to my bucket list ✈️', time: '6m', likes: 1),
        ],
      ),
      CommentData(id: '4', name: 'Emily Davis', avatar: 'https://i.pravatar.cc/150?img=14', text: 'The colors are so beautiful!', time: '15m', likes: 4),
      CommentData(id: '5', name: 'Alex Johnson', avatar: 'https://i.pravatar.cc/150?img=15', text: 'Living the dream! 🙌', time: '20m', likes: 6),
    ];
  }

  int get totalReplies => replies.length;
}
