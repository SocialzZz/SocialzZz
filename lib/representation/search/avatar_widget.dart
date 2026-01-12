import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final Color accent;
  final String? imageUrl;

  const AvatarWidget({super.key, required this.accent, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFFF3F4F6),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Icon(Icons.landscape, size: 20, color: accent.withAlpha(144))
          : null,
    );
  }
}
