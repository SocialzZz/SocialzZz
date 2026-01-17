import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Đảm bảo không bị dính vào tai thỏ/camera
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 2), // Đẩy cụm logo xuống 1 chút từ đỉnh
              // --- CỤM TRÊN: LOGO & GIỚI THIỆU ---
              Image.asset(
                'assets/images/SocialzZz-Logo.jpg',
                width: 140,
                height: 140,
              ),
              const SizedBox(height: 20),
              const Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'Welcome to ',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  children: [
                    TextSpan(
                      text: 'SocialzZz',
                      style: TextStyle(color: Color(0xFFF9622E)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Connect, share, and be yourself every day. Capture memories and find inspiration from those who matter.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(
                    255,
                    101,
                    100,
                    100,
                  ), // Làm mờ mô tả để nổi bật tiêu đề
                  height: 1.5, // Khoảng cách dòng cho dễ đọc
                ),
              ),

              const Spacer(flex: 3), // Khoảng trống lớn ở giữa để giãn cách
              // --- CỤM DƯỚI: NÚT BẤM ---
              SizedBox(
                width: double.infinity, // Nút rộng hết cỡ
                height: 55, // Nút cao hơn để dễ bấm
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9622E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // Bo góc hiện đại
                    ),
                    elevation: 0,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.register),
                  child: const Text(
                    "Let's Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: 'Sign in',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF9622E),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RouteNames.login);
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
