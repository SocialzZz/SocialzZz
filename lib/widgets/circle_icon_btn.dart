// lib/widgets/circle_icon_button.dart

import 'package:flutter/material.dart';

const Color _borderColor = Color(0xFFE2E5E9);
const Color _iconColor = Color(0xFF1D1B20);

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;

  const CircleIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.iconSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Xử lý sự kiện bấm
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: _borderColor),
        ),
        child: Icon(icon, size: iconSize, color: _iconColor),
      ),
    );
  }
}
