class Message {
  final String id;
  final String content;
  final String senderId;
  final String receiverId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageUser? sender;
  final MessageUser? receiver;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      sender: json['sender'] != null
          ? MessageUser.fromJson(json['sender'])
          : null,
      receiver: json['receiver'] != null
          ? MessageUser.fromJson(json['receiver'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sender': sender?.toJson(),
      'receiver': receiver?.toJson(),
    };
  }
}

class MessageUser {
  final String id;
  final String? name;
  final String? avatarUrl;

  MessageUser({
    required this.id,
    this.name,
    this.avatarUrl,
  });

  factory MessageUser.fromJson(Map<String, dynamic> json) {
    return MessageUser(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }
}

class Conversation {
  final MessageUser partner;
  final Message lastMessage;
  final int unreadCount;

  Conversation({
    required this.partner,
    required this.lastMessage,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      partner: MessageUser.fromJson(json['partner']),
      lastMessage: Message.fromJson(json['lastMessage']),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
