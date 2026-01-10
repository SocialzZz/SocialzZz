import 'package:flutter/material.dart';

// --- MODELS ---
enum SettingType { navigation, toggle, info, logout, destructive }

class SettingItem {
  final String id;
  final String title;
  final String subtitle; // Subtitle is now mandatory for better UX
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
  // Constants Colors
  static const Color mainOrange = Color(0xFFF9622E);
  static const Color borderColor = Color(0xFFE2E5E9);
  static const Color textColor = Color(0xFF1D1B20);
  static const Color destructiveColor = Color(0xFFD32F2F);

  // DATA SOURCES

  //  Account Section
  List<SettingItem> accountSettings = [
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

  //  Appearance Section
  List<SettingItem> appearanceSettings = [
    SettingItem(
      id: 'theme',
      title: 'Theme',
      subtitle: 'Light & Dark mode',
      icon: Icons.palette_outlined, // Or brightness_6_outlined
      type: SettingType
          .navigation, // Usually opens a modal/screen to select theme
    ),
  ];

  //  General Section (Notifications, Language)
  List<SettingItem> generalSettings = [
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
      type: SettingType.navigation,
    ),
  ];

  //  Other Section (About, Delete)
  List<SettingItem> otherSettings = [
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
      type: SettingType.destructive, // Custom type for red text/icon
    ),
  ];

  bool _isLoading = false;

  // --- LOGIC FUNCTIONS ---

  void _handleItemTap(SettingItem item) {
    if (item.type == SettingType.toggle) {
      setState(() {
        item.value = !item.value;
      });
      debugPrint("Update setting ${item.id} to ${item.value}");
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
        content: const Text("This action cannot be undone. Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleLogout(); // Reuse logout for demo
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
    if (mounted) {
      setState(() => _isLoading = false);
      debugPrint("User logged out");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      body: Stack(
        children: [
          //  Header (Back Button + Title)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // Back Button
                    Container(
                      width: 32,
                      height: 32,
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

                    // Title
                    const Expanded(
                      child: Text(
                        "Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32), // Balance spacing
                  ],
                ),
              ),
            ),
          ),

          //  White Card Content
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  children: [
                    _buildSectionTitle("ACCOUNT"),
                    ...accountSettings.map((e) => _buildSettingTile(e)),

                    const SizedBox(height: 20),
                    _buildSectionTitle("APPEARANCE"),
                    ...appearanceSettings.map((e) => _buildSettingTile(e)),

                    const SizedBox(height: 20),
                    _buildSectionTitle("GENERAL"),
                    ...generalSettings.map((e) => _buildSettingTile(e)),

                    const SizedBox(height: 20),
                    _buildSectionTitle("OTHER"),
                    ...otherSettings.map((e) => _buildSettingTile(e)),

                    const SizedBox(height: 30),

                    // Logout Button
                    _buildLogoutButton(),

                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Version 1.0.0",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black12,
              child: const Center(
                child: CircularProgressIndicator(color: mainOrange),
              ),
            ),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingTile(SettingItem item) {
    final bool isDestructive = item.type == SettingType.destructive;
    final Color itemColor = isDestructive ? destructiveColor : mainOrange;
    final Color titleColor = isDestructive ? destructiveColor : textColor;

    return Container(
      // Bỏ margin bottom để các dòng gạch chân liền mạch hơn, hoặc giữ nhỏ nếu muốn thoáng
      margin: const EdgeInsets.only(bottom: 0),
      decoration: const BoxDecoration(
        color: Colors.transparent, // Không nền
        // Chỉ có border bottom màu đen (theo yêu cầu)
        border: Border(
          bottom: BorderSide(
            color: Colors
                .black12, // Màu đen nhạt (hoặc Colors.black nếu muốn đen tuyền)
            width: 1.0,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleItemTap(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 16,
            ), // Padding thoáng hơn
            child: Row(
              children: [
                // Icon (Không nền, không border)
                Icon(item.icon, color: itemColor, size: 26),

                const SizedBox(width: 16),

                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Action
                if (item.type == SettingType.toggle)
                  Switch.adaptive(
                    value: item.value,
                    activeColor: mainOrange,
                    onChanged: (val) => _handleItemTap(item),
                  )
                else
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
              ],
            ),
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
            Icon(Icons.logout, color: Color(0xFFD32F2F), size: 20),
            SizedBox(width: 8),
            Text(
              "Log Out",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                color: Color(0xFFD32F2F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
