import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset(
                'assets/images/welcome.svg',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 26),
              const Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'Welcome to ',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  children: [
                    TextSpan(
                      text: 'SocialzZz',
                      style: TextStyle(color: Color(0xFFF9622E)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Connect, share, and be yourself every day. Capture memories and find inspiration from those who matter.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 101, 100, 100),
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9622E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.step),
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
