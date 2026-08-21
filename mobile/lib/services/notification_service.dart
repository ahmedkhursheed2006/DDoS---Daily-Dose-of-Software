import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    debugPrint('NotificationService initialized successfully.');
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    debugPrint('Daily dose reminder scheduled for $hour:$minute.');
  }

  Future<void> cancelAllNotifications() async {
    debugPrint('All scheduled notifications cancelled.');
  }
}
