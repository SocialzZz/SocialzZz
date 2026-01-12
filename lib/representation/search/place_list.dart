import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/search_item.dart';
import 'avatar_widget.dart';

class PlaceList extends StatelessWidget {
  final List<PlaceItem> places;
  final Color accentColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color dividerColor;

  const PlaceList({
    super.key,
    required this.places,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(
        child: Text(
          'No places found',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      itemCount: places.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: dividerColor),
      itemBuilder: (context, index) {
        final place = places[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              AvatarWidget(accent: accentColor, imageUrl: place.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    if (place.address != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        place.address!,
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
