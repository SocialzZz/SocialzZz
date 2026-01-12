import 'package:flutter/material.dart';

class ReactionCounter extends StatelessWidget {
  final int count;
  
  const ReactionCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.pink.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.pink, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          "$count người đã thả tim",
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}