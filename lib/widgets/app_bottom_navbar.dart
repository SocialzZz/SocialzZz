import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.primaryColor,
  });

  final int selectedIndex;
  final Function(int) onItemTapped;
  final Color primaryColor;

  Widget _buildNavItem(
    IconData icon,
    int index,
    Color activeColor,
    Function(int) onTap, {
    double size = 28,
    Color? defaultColor,
  }) {
    final bool isSelected = index == selectedIndex;

    Color iconColor;
    if (isSelected) {
      iconColor = activeColor;
    } else {
      // Nếu có defaultColor, dùng nó. Nếu không, dùng Colors.grey
      iconColor = defaultColor ?? Colors.grey;
    }

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: size),
              // Thanh gạch chân màu cam
              if (isSelected && selectedIndex != 2)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 3,
                  width: 25,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = primaryColor;
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 1),
        ],
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, 0, primaryColor, onItemTapped),

            _buildNavItem(Icons.ondemand_video, 1, primaryColor, onItemTapped),

            _buildNavItem(
              Icons.add_circle_outline,
              2,
              primaryColor,
              onItemTapped,
              size: 45,
              defaultColor: activeColor,
            ),

            _buildNavItem(
              Icons.chat_bubble_outline,
              3,
              primaryColor,
              onItemTapped,
            ),

            _buildNavItem(Icons.person_outline, 4, primaryColor, onItemTapped),
          ],
        ),
      ),
    );
  }
}
