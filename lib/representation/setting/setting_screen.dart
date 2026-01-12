import 'package:flutter/material.dart';

// --- MODELS ---
enum SettingType { navigation, toggle, info, logout, destructive }

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

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Colors
  static const Color mainOrange = Color(0xFFF9622E);
  static const Color borderColor = Color(0xFFE2E5E9);
  static const Color textColor = Color(0xFF1D1B20);
  static const Color destructiveColor = Color(0xFFD32F2F);

  // DATA
  final List<SettingItem> accountSettings = [
    SettingItem(
      id: 'edit_profile',
      title: 'Edit Profile',
      subtitle: 'Update your personal information',
      icon: Icons.person_outline,
    ),
    SettingItem(
      id: 'change_password',
      title: 'Change Password',
      subtitle: 'Ensure your account security',
      icon: Icons.lock_outline,
    ),
    SettingItem(
      id: 'privacy',
      title: 'Privacy',
      subtitle: 'Control who sees your profile',
      icon: Icons.privacy_tip_outlined,
    ),
  ];

  final List<SettingItem> appearanceSettings = [
    SettingItem(
      id: 'theme',
      title: 'Theme',
      subtitle: 'Light & Dark mode',
      icon: Icons.palette_outlined,
    ),
  ];

  final List<SettingItem> generalSettings = [
    SettingItem(
      id: 'notification',
      title: 'Notifications',
      subtitle: 'Manage push notifications',
      icon: Icons.notifications_none,
      type: SettingType.toggle,
      value: true,
    ),
    SettingItem(
      id: 'language',
      title: 'Language',
      subtitle: 'English (Default)',
      icon: Icons.language,
    ),
  ];

  final List<SettingItem> otherSettings = [
    SettingItem(
      id: 'about_us',
      title: 'About Us',
      subtitle: 'Learn more about our team',
      icon: Icons.info_outline,
    ),
    SettingItem(
      id: 'delete_account',
      title: 'Delete Account',
      subtitle: 'Permanently remove your account',
      icon: Icons.delete_outline,
      type: SettingType.destructive,
    ),
  ];

  bool _isLoading = false;

  // LOGIC
  void _handleItemTap(SettingItem item) {
    if (item.type == SettingType.toggle) {
      setState(() => item.value = !item.value);
    } else if (item.type == SettingType.destructive) {
      _showDeleteConfirmation();
    } else {
      debugPrint("Navigate to ${item.id}");
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Account?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleLogout();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Container(
      color: mainOrange,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: const Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
              const Expanded(
                child: Text(
                  "Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
        ),
      ),
    );
  }

  // CONTENT
  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          children: [
            _buildSectionTitle("ACCOUNT"),
            ...accountSettings.map(_buildSettingTile),
            const SizedBox(height: 20),

            _buildSectionTitle("APPEARANCE"),
            ...appearanceSettings.map(_buildSettingTile),
            const SizedBox(height: 20),

            _buildSectionTitle("GENERAL"),
            ...generalSettings.map(_buildSettingTile),
            const SizedBox(height: 20),

            _buildSectionTitle("OTHER"),
            ...otherSettings.map(_buildSettingTile),
            const SizedBox(height: 30),

            _buildLogoutButton(),
            const SizedBox(height: 20),

            Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // COMPONENTS
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingTile(SettingItem item) {
    final bool isDestructive = item.type == SettingType.destructive;
    final Color iconColor = isDestructive ? destructiveColor : mainOrange;
    final Color titleColor = isDestructive ? destructiveColor : textColor;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: InkWell(
        onTap: () => _handleItemTap(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Icon(item.icon, color: iconColor, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (item.type == SettingType.toggle)
                Switch.adaptive(
                  value: item.value,
                  activeColor: mainOrange,
                  onChanged: (_) => _handleItemTap(item),
                )
              else
                Icon(Icons.chevron_right,
                    color: Colors.grey[400], size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _handleLogout,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEECE5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: destructiveColor, size: 20),
            SizedBox(width: 8),
            Text(
              "Log Out",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: destructiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black12,
      child: const Center(
        child: CircularProgressIndicator(color: mainOrange),
      ),
    );
  }
}
