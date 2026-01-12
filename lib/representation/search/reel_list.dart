import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/search_item.dart';
import 'avatar_widget.dart';

class ReelList extends StatelessWidget {
  final List<ReelItem> reels;
  final Color accentColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color dividerColor;

  const ReelList({
    super.key,
    required this.reels,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.dividerColor,
  });

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (reels.isEmpty) {
      return const Center(
        child: Text(
          'No reels found',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      itemCount: reels.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: dividerColor),
      itemBuilder: (context, index) {
        final reel = reels[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              AvatarWidget(accent: accentColor, imageUrl: reel.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reel.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    if (reel.views != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${_formatViews(reel.views!)} views',
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
