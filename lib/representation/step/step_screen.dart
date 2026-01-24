import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/step_model.dart';
import 'package:flutter_social_media_app/representation/step/step_item.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<StepModel> steps = [
    StepModel(
      title: "See What",
      highlightText: "Your Connections",
      lastTitle: "Are Sharing",
      description:
          "Stay updated with the latest moments from your friends and family. Share your own stories and keep in touch with your loved ones, no matter where you are.",
      imagePath: "assets/images/connect.svg",
    ),
    StepModel(
      title: "Discover the",
      highlightText: "Best Short Videos",
      lastTitle: "from the Crowd",
      description:
          "Experience endless entertainment with creative, trending short videos. Discover the world through the unique lenses of the SocialzZz community.",
      imagePath: "assets/images/video.svg",
    ),
    StepModel(
      title: "Explore ",
      highlightText: "Profiles",
      lastTitle: "for Making Connections",
      description:
          "Build an impressive personal profile and connect with people who share your passions. Search, find, and expand your social circle with just a few taps",
      imagePath: "assets/images/profile.svg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.register,
                (route) => false,
              );
            },
            child: const Text(
              "Skip",
              style: TextStyle(fontSize: 20, color: Color(0xFFF9622E)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: steps.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) => StepItem(model: steps[index]),
            ),
          ),
          _buildBottomControl(),
        ],
      ),
    );
  }

  Widget _buildBottomControl() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleButton(Icons.arrow_back, Colors.grey[200]!, Colors.black, () {
            _pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }),

          // Indicators
          Row(
            children: List.generate(steps.length, (index) => _buildDot(index)),
          ),

          _circleButton(
            Icons.arrow_forward,
            Color(0xFFF9622E),
            Colors.white,
            () {
              if (_currentIndex < steps.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.register,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton(
    IconData icon,
    Color bg,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentIndex == index
            ? Color(0xFFF9622E)
            : Color(0xFFF9622E).withAlpha(36),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
