import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final bool requestSent;
  final bool isFriend;
  final Color accent;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onUnfriend; // Thêm callback cho Unfriend

  const FollowButton({
    super.key,
    required this.isFollowing,
    this.requestSent = false,
    this.isFriend = false,
    required this.accent,
    this.onTap,
    this.onCancel,
    this.onUnfriend,
  });

  @override
  Widget build(BuildContext context) {
    // 1. TRƯỜNG HỢP: ĐÃ LÀ BẠN -> Hiển thị "Unfriend"
    if (isFriend) {
      return GestureDetector(
        onTap: onUnfriend,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.red.shade300, width: 1.4),
          ),
          child: Text(
            'Unfriend',
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // 2. TRƯỜNG HỢP: ĐÃ GỬI YÊU CẦU -> Hiển thị "Pending" (Thay cho Cancel Request)
    if (requestSent) {
      return GestureDetector(
        onTap: onCancel,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent, width: 1.4),
            color: accent.withOpacity(0.1), // Làm nổi bật trạng thái chờ
          ),
          child: Text(
            'Pending',
            style: TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // 3. TRƯỜNG HỢP MẶC ĐỊNH: CHƯA GỬI -> Hiển thị "Add Friend"
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'Add Friend',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
