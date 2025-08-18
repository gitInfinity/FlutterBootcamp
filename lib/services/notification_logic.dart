import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notesapp/main_page/main_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    const androidDetails = AndroidNotificationDetails(
      'reminders_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      category: AndroidNotificationCategory.reminder,
    );
    return NotificationDetails(android: androidDetails);
  }

  static Future init(BuildContext context, String uid) async {
    tz.initializeTimeZones();

    final android = AndroidInitializationSettings("@mipmap/ic_launcher");
    final settings = InitializationSettings(android: android);

    await _notifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: (details) {
        onNotifications.add(details.payload);
      },
    );

    await _requestPermissions();
  }

  static Future _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {
    try {
      if (dateTime.isAfter(DateTime.now())) {
        print('Scheduling notification: $title at $dateTime');
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(dateTime, tz.local),
          await _notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        print('Notification scheduled successfully');
      } else {
        print('Notification time is in the past: $dateTime');
      }
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  static Future cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future testNotification() async {
    await _notifications.show(
      999,
      'Test Notification',
      'This is a test notification',
      await _notificationDetails(),
    );
  }

  static Future<bool> areExactAlarmsAllowed() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }
    return false;
  }
}

void listenNotifications() {
  NotificationLogic.onNotifications.listen((payload) {});
}

void onClickNotification(BuildContext context, String? payload) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MainPage()),
  );
}
