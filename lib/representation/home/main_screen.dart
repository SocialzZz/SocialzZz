import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/representation/auth/auth_service.dart';
import 'package:flutter_social_media_app/representation/home/home_screen.dart';
import 'package:flutter_social_media_app/representation/post/screens/create_post_screen.dart';
import 'package:flutter_social_media_app/representation/profile/profile_screen.dart';
import 'package:flutter_social_media_app/representation/video/video_screen.dart';
import '../../widgets/app_bottom_navbar.dart';
import '../message/message_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _currentUserId; // Biến lưu ID lấy từ SharedPreferences
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Lấy ID người dùng khi app khởi động
  Future<void> _loadUser() async {
    final id = await _authService.getUserId();
    print(
      "Current User ID loaded: $id",
    ); // Thêm dòng này để debug trong console

    if (mounted) {
      setState(() {
        _currentUserId = id;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Nếu chưa load xong ID, hiển thị màn hình chờ
    if (_currentUserId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Danh sách màn hình giờ đã có userId thực tế
    final List<Widget> screens = [
      const HomeScreen(),
      const VideoScreen(),
      const CreatePostScreen(),
      const MessageListScreen(),
      ProfileScreen(userId: _currentUserId!), // Truyền ID thực tế vào đây
    ];

    return Scaffold(
      extendBody: true,
      body: screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
        child: AppBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          primaryColor: const Color(0xFFF9622E),
        ),
      ),
    );
  }
}
