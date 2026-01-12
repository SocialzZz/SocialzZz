import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';

class PostInput extends StatelessWidget {
  final CreatePostController controller;
  
  const PostInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.contentController,
      maxLines: null,
      minLines: 6,
      style: const TextStyle(fontSize: 18, color: Colors.black87),
      decoration: const InputDecoration(
        hintText: 'Bạn đang nghĩ gì thế?',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
        border: InputBorder.none,
      ),
    );
  }
}