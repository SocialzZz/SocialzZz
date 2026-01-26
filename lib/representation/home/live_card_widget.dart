import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        // Đảm bảo các thành phần con (như ảnh nền) bị cắt theo bo góc của Container
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300], // Màu nền chờ trong khi load
        ),
        child: Stack(
          children: [
            // --- 1. LỚP NỀN (SVG BACKGROUND) ---
            Positioned.fill(
              child: ColorFiltered(
                // Áp dụng bộ lọc làm tối ảnh nền
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha(100),
                  BlendMode.darken,
                ),
                child: SvgPicture.asset(
                  data.backgroundImageURL,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // --- 2. NÚT ADD (NẾU LÀ "YOU") ---
            if (data.isYou)
              const Center(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.add, size: 30, color: Colors.black54),
                ),
              ),

            // --- 3. THÔNG TIN USER (AVATAR SVG + NAME) ---
            Positioned(
              bottom: 10,
              left: 8,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF9622E),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        data.avatarURL,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
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
