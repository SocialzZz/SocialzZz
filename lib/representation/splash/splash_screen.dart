import 'package:flutter/material.dart';
import '../../routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Thêm mixin này để dùng AnimationController

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Khởi tạo AnimationController (Thời gian hiệu ứng là 1.5 giây)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 2. Tạo hiệu ứng mờ dần (Opacity Animation) từ 0.0 đến 1.0
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn, // Sử dụng curve để hiệu ứng mượt mà hơn
      ),
    );

    // Bắt đầu hiệu ứng Fade In
    _controller.forward();

    // 3. Chuyển màn hình sau khi hiệu ứng hoàn tất + một chút thời gian chờ
    // Tổng thời gian chờ: 1.5 giây (hiệu ứng) + 1.5 giây (chờ) = 3 giây
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.welcome);
      }
    });
  }

  // Rất quan trọng: Giải phóng Controller khi widget bị hủy
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Nên đặt màu nền để hiệu ứng mờ nhìn rõ hơn
      body: Center(
        // Sử dụng FadeTransition để áp dụng hiệu ứng mờ dần lên Logo
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: const Image(
            image: AssetImage('assets/images/SocialzZz-Logo.jpg'),
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
