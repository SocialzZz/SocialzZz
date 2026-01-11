import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/widgets/circle_icon_btn.dart';

class MessageHeader extends StatelessWidget {
  const MessageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 30), // Dùng để căn giữa tiêu đề
          const Text(
            'Messages',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          CircleIconButton(icon: Icons.search_sharp, onPressed: () {}),
        ],
      ),
    );
  }
}
