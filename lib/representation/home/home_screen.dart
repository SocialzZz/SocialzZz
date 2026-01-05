import 'package:flutter/material.dart';
import '../../widgets/app_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text("Home Screen")),
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
        padding: EdgeInsets.fromLTRB(10, 0, 10, 25),
        child: AppBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          primaryColor: primaryColor,
        ),
      ),
    );
  }
}
