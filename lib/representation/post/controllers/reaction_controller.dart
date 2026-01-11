import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Uncomment when Firebase is set up

class ReactionUser {
  final String id;
  final String name;
  final String avatarUrl;
  final String reactionType;
  final DateTime? timestamp;

  ReactionUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.reactionType,
    this.timestamp,
  });

  factory ReactionUser.fromFirestore(Map<String, dynamic> data, String id) {
    return ReactionUser(
      id: id,
      name: data['displayName'] ?? 'Người dùng ẩn danh',
      avatarUrl: data['photoURL'] ?? 'https://placehold.co/100x100/png?text=User',
      reactionType: data['type'] ?? 'heart',
      // timestamp: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ReactionController {
  final String? postId;
  late Stream<List<ReactionUser>> reactionsStream;

  ReactionController({this.postId}) {
    reactionsStream = _getMockReactionsStream();
    // reactionsStream = _getRealFirebaseStream(); // Use this when Firebase is ready
  }

  // Mock stream for demo
  Stream<List<ReactionUser>> _getMockReactionsStream() async* {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    yield List.generate(20, (index) => ReactionUser(
      id: 'user_$index',
      name: 'User Name $index',
      avatarUrl: 'https://placehold.co/100x100/png?text=U$index',
      reactionType: 'heart',
    ));
  }

  // Real Firebase stream (commented for now)
  /*
  Stream<List<ReactionUser>> _getRealFirebaseStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('reactions') 
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ReactionUser.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }
  */
}