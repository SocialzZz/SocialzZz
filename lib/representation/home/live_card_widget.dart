import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/live_card_data.dart';

class LiveCardWidget extends StatelessWidget {
  final LiveCardData data;

  const LiveCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 140;
    const double cardHeight = 220;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(data.backgroundImageURL),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(100),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            if (data.isYou)
              const Center(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.add, size: 30, color: Colors.black54),
                ),
              ),
            Positioned(
              bottom: 10,
              left: 8,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(data.avatarURL),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    data.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
