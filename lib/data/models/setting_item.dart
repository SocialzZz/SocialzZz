import 'package:flutter/material.dart';

// --- ENUMS ---
enum SettingType { navigation, toggle, info, logout, destructive }

// --- MODEL CLASS ---
class SettingItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final SettingType type;
  bool value;

  SettingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.type = SettingType.navigation,
    this.value = false,
  });
}
