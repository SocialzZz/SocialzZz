import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/data/models/step_model.dart';
import 'package:flutter_svg/svg.dart';

class StepItem extends StatelessWidget {
  final StepModel model;

  const StepItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SvgPicture.asset(model.imagePath, width: 320, height: 320),
          ),
        ),

        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: model.title),
                      TextSpan(
                        text: " ${model.highlightText} ",
                        style: const TextStyle(color: Color(0xFFF9622E)),
                      ),
                      TextSpan(text: model.lastTitle),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  model.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 98, 97, 97),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
