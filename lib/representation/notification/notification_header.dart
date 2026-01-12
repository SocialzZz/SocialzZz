import 'package:flutter/material.dart';

class NotificationHeader extends StatelessWidget {
  final int pendingRequestsCount;
  final Color accentColor;

  const NotificationHeader({
    super.key,
    required this.pendingRequestsCount,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(
            child: Text(
              'Notification',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
          ),
          if (pendingRequestsCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '$pendingRequestsCount Requests',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            )
          else
            const SizedBox(width: 100), // Spacer to center title
        ],
      ),
    );
  }
}
