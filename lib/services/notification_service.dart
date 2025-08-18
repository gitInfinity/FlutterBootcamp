import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Request permissions
    await _requestPermissions();

    // Initialize notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<void> _requestPermissions() async {
    print('🔐 Requesting notification permissions...');
    await Permission.notification.request();
    print('🔐 Requesting calendar permissions...');
    await Permission.calendarWriteOnly.request();
    
    // Request exact alarm permission on Android 12+
    if (Platform.isAndroid) {
      print('🔐 Requesting exact alarm permission...');
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    print('⏰ Scheduling reminder: ID=$id, Title="$title", Time=$scheduledDate');
    
    final scheduledDateTz = tz.TZDateTime.from(scheduledDate, tz.local);
    print('⏰ Converted to timezone: $scheduledDateTz');

    try {
      print('⏰ Attempting exact scheduling...');
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDateTz,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders_channel',
            'Reminders',
            channelDescription: 'Reminder notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('✅ Reminder scheduled successfully with exact timing');
    } catch (e) {
      print('⚠️ Exact scheduling failed: $e');
      print('⏰ Falling back to inexact scheduling...');
      
      // Fallback to inexact scheduling if exact fails
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDateTz,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders_channel',
            'Reminders',
            channelDescription: 'Reminder notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('✅ Reminder scheduled with inexact timing');
    }
  }

  Future<void> cancelReminder(int id) async {
    print('❌ Cancelling reminder: ID=$id');
    await _notifications.cancel(id);
    print('✅ Reminder cancelled');
  }

  Future<void> cancelAllReminders() async {
    print('❌ Cancelling all reminders');
    await _notifications.cancelAll();
    print('✅ All reminders cancelled');
  }
}
