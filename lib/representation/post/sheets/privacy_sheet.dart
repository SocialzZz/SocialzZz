import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';

class PrivacySheet {
  static const Color mainOrange = Color(0xFFF9622E);
  
  static void show(BuildContext context, CreatePostController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Ai có thể xem bài viết này?", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.public, color: Colors.blue),
                    title: const Text("Công khai (Public)"),
                    subtitle: const Text("Bất kỳ ai trên hoặc ngoài ứng dụng"),
                    trailing: controller.selectedPrivacy == 'PUBLIC'  
                      ? const Icon(Icons.check, color: mainOrange) 
                      : null,
                    onTap: () {
                      controller.setPrivacy('PUBLIC');  
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock, color: Colors.red),
                    title: const Text("Chỉ mình tôi (Private)"),
                    subtitle: const Text("Chỉ bạn mới có thể xem bài viết này"),
                    trailing: controller.selectedPrivacy == 'PRIVATE' 
                      ? const Icon(Icons.check, color: mainOrange) 
                      : null,
                    onTap: () {
                      controller.setPrivacy('PRIVATE');  
                      Navigator.pop(context);
                    },
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.people, color: Colors.green),
                  //   title: const Text("Bạn bè"),
                  //   subtitle: const Text("Chỉ bạn bè của bạn mới xem được"),
                  //   trailing: controller.selectedPrivacy == 'FRIENDS'  // ← Thêm option FRIENDS
                  //     ? const Icon(Icons.check, color: mainOrange) 
                  //     : null,
                  //   onTap: () {
                  //     controller.setPrivacy('FRIENDS');
                  //     Navigator.pop(context);
                  //   },
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}