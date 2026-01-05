import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/routes/route_names.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/SocialzZz-Logo.jpg',
              width: 120,
              height: 120,
            ),

            SizedBox(height: 10),

            const Text.rich(
              TextSpan(
                text: 'Welcome to ',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                children: [
                  TextSpan(
                    text: 'SocialzZz',
                    style: TextStyle(fontSize: 25, color: Color(0xFFF9622E)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5),

            const SizedBox(
              width: 300,
              child: Text(
                "A place to connect, share moments, and be yourself every day. Capture the highlights of your life and discover new inspirations from people who truly matter to you.",
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
            ),

            SizedBox(height: 35),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF9622E),
              ),
              child: Text(
                "Let's Get Started",
                style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
              ),
              onPressed: () => {
                Navigator.pushNamed(context, RouteNames.register),
              },
            ),

            SizedBox(height: 10),

            Text.rich(
              TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(fontSize: 16),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFF9622E),
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
          ],
        ),
      ),
    );
  }
}
