import 'package:flutter/material.dart';
import '../controllers/create_post_controller.dart';
import '../sheets/image_picker_sheet.dart';
import '../sheets/tag_friend_sheet.dart';
import '../sheets/feeling_sheet.dart';

class PostActionBar extends StatelessWidget {
  final CreatePostController controller;
  
  const PostActionBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10, 
            offset: const Offset(0, -2)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                "Thêm vào bài viết", 
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)
              ), 
              Spacer()
            ]
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionIcon(
                context,
                Icons.image, 
                const Color(0xFF45BD62), 
                onTap: () => ImagePickerSheet.show(context, controller, isGif: false)
              ),
              _buildActionIcon(
                context,
                Icons.person_add_alt_1, 
                const Color(0xFF1877F2), 
                onTap: () => TagFriendSheet.show(context, controller)
              ),
              _buildActionIcon(
                context,
                Icons.sentiment_satisfied_alt, 
                const Color(0xFFF7B928), 
                onTap: () => FeelingSheet.show(context, controller)
              ),
              _buildActionIcon(
                context,
                Icons.location_on, 
                const Color(0xFFF02849), 
                onTap: () => _showSimpleSelector(
                  context,
                  "Check-in", 
                  ["Hồ Chí Minh", "Hà Nội", "Đà Nẵng", "Cần Thơ"], 
                  (val) => controller.setLocation(val)
                )
              ),
              _buildActionIcon(
                context,
                Icons.gif_box, 
                const Color(0xFFAB47BC), 
                onTap: () => ImagePickerSheet.show(context, controller, isGif: true)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(BuildContext context, IconData icon, Color color, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), 
          shape: BoxShape.circle
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  void _showSimpleSelector(BuildContext context, String title, List<String> items, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16), 
              child: Text(
                title, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              )
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true, 
                itemCount: items.length, 
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(items[index]), 
                    onTap: () { 
                      onSelected(items[index]); 
                      Navigator.pop(context); 
                    }
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}