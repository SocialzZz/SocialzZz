import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/representation/home/home_screen.dart';
import '../../widgets/app_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text("Reels/Discovery Screen")),
    const Center(child: Text("Create Post Screen")),
    const Center(child: Text("Messages Screen")),
    const Center(child: Text("Profile Screen")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFF9622E);

    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
        child: AppBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          primaryColor: primaryColor,
        ),
      ),
    );
  }
}
