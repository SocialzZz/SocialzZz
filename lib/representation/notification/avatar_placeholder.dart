import 'package:flutter/material.dart';

class AvatarPlaceholder extends StatelessWidget {
  final Color accent;
  final String? imageUrl;

  const AvatarPlaceholder({super.key, required this.accent, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFFF3F4F6),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Icon(Icons.landscape, size: 20, color: accent.withAlpha(153))
          : null,
    );
  }
}
