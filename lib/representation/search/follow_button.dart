import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final bool requestSent;
  final bool isFriend;
  final Color accent;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const FollowButton({
    super.key,
    required this.isFollowing,
    this.requestSent = false,
    this.isFriend = false,
    required this.accent,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // If already friends
    if (isFriend) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey, width: 1.4),
        ),
        child: const Text(
          'Friends',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    // If request sent - show Cancel button
    if (requestSent) {
      return GestureDetector(
        onTap: onCancel,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent, width: 1.4),
          ),
          child: Text(
            'Cancel request',
            style: TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    // Default - Add Friend button
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