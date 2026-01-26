import 'package:flutter/material.dart';

class NotificationManager {
  // Singleton để truy cập ở mọi nơi
  static final NotificationManager instance = NotificationManager._internal();
  NotificationManager._internal();

  // ValueNotifier để lắng nghe sự thay đổi của số thông báo
  final ValueNotifier<int> notificationCount = ValueNotifier<int>(0);

  void updateCount(int count) {
    notificationCount.value = count;
  }
}
