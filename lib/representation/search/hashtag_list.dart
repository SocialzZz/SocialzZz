import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/search_item.dart';
import 'avatar_widget.dart';

class HashtagList extends StatelessWidget {
  final List<HashtagItem> hashtags;
  final Color accentColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color dividerColor;

  const HashtagList({
    super.key,
    required this.hashtags,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    if (hashtags.isEmpty) {
      return const Center(
        child: Text(
          'No hashtags found',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      itemCount: hashtags.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: dividerColor),
      itemBuilder: (context, index) {
        final hashtag = hashtags[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              AvatarWidget(accent: accentColor, imageUrl: hashtag.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${hashtag.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    if (hashtag.postCount != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        hashtag.subtitle ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
