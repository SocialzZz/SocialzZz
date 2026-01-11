import 'package:flutter/material.dart';
import '../controllers/reaction_controller.dart';

class ReactionItem extends StatelessWidget {
  final ReactionUser user;
  
  const ReactionItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar with heart badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red, 
                    shape: BoxShape.circle
                  ),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(
                    Icons.favorite, 
                    size: 10, 
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(width: 12),
        
        // User info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1D1B20),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Đã thả tim",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}