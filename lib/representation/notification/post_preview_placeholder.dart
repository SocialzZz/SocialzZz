import 'package:flutter/material.dart';

class PostPreviewPlaceholder extends StatelessWidget {
  final Color accent;

  const PostPreviewPlaceholder({super.key, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(Icons.landscape, size: 24, color: accent.withAlpha(153)),
    );
  }
}
