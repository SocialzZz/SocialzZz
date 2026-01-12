import 'package:flutter/material.dart';

class SearchTabs extends StatelessWidget {
  final int selectedTab;
  final Color accentColor;
  final Color textSecondaryColor;
  final Function(int) onTabChanged;

  const SearchTabs({
    super.key,
    required this.selectedTab,
    required this.accentColor,
    required this.textSecondaryColor,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (icon: Icons.person_outline, label: 'Account'),
      (icon: Icons.live_tv, label: 'Reel'),
      (icon: Icons.place_outlined, label: 'Place'),
      (icon: Icons.tag, label: 'Hashtag'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(tabs.length, (index) {
        final isActive = selectedTab == index;
        return Expanded(
          child: InkWell(
            onTap: () => onTabChanged(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[index].icon,
                      size: 18,
                      color: isActive ? accentColor : textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tabs[index].label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive ? accentColor : textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: 42,
                  decoration: BoxDecoration(
                    color: isActive ? accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
