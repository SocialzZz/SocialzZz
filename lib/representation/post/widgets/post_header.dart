import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';
import '../sheets/privacy_sheet.dart';

class PostHeader extends StatelessWidget {
  final CreatePostController controller;
  
  const PostHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
          backgroundColor: Color(0xFFEADDFF),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Nguyễn Văn A', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      color: Colors.black87
                    )
                  ),
                  if (controller.selectedFeeling != null) ...[
                    const Text(
                      " đang cảm thấy ", 
                      style: TextStyle(color: Colors.grey, fontSize: 13)
                    ),
                    Text(
                      controller.selectedFeeling!, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => controller.setFeeling(null),
                      child: const Icon(Icons.close, size: 14, color: Colors.grey),
                    )
                  ],
                  if (controller.selectedLocation != null) ...[
                    const Text(
                      " tại ", 
                      style: TextStyle(color: Colors.grey, fontSize: 13)
                    ),
                    Text(
                      controller.selectedLocation!, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => PrivacySheet.show(context, controller),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300), 
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.selectedPrivacy == 'Public' ? Icons.public : Icons.lock, 
                        size: 12, 
                        color: Colors.grey
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.selectedPrivacy == 'Public' ? 'Công khai' : 'Riêng tư', 
                        style: const TextStyle(fontSize: 12, color: Colors.grey)
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}