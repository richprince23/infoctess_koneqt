import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    flnp
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    tz.initializeTimeZones();
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('ic_launcher');
    DarwinInitializationSettings ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          // print("Notification Received $id, $title, $body, $payload");
        });
    var initSettings = InitializationSettings(android: android, iOS: ios);
    await flnp.initialize(
      initSettings,
      // onDidReceiveBackgroundNotificationResponse: (details) async {},
      onDidReceiveNotificationResponse: (details) {
        print("Notification Received ${details.id}, ${details.payload}");
      },
    );
    await flnp.initialize(initSettings);
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'shedulesChannel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(
          presentSound: true, presentAlert: true, presentBadge: true),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return flnp.show(id, title, body, await notificationDetails());
  }

  Future<void> scheduleNotification(String day, String time) async {
    var dayOfWeek = _getDayOfWeek(day);
    var scheduledNotificationDateTime = tz.TZDateTime(
      tz.local,
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _getTimeOfDay(time).hour,
      _getTimeOfDay(time).minute,
    );
    // while (scheduledNotificationDateTime.weekday != dayOfWeek) {
    //   scheduledNotificationDateTime =
    //       scheduledNotificationDateTime.add(const Duration(days: 1));
    // }
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channelId2',
      'shedulesReminderChannels',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
        presentSound: true, presentAlert: true, presentBadge: true);
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    print(scheduledNotificationDateTime);

    await flnp.zonedSchedule(
      1,
      'Scheduled Class Reminder',
      'You have an upcoming class at $time',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'Scheduled Class Reminder $day',
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  int _getDayOfWeek(String day) {
    switch (day.toLowerCase()) {
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      case 'Sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }

  TimeOfDay _getTimeOfDay(String time) {
    var components = time.split(':');
    var hour = int.tryParse(components[0]) ?? 0;
    var minutePart = components[1].substring(0, 2);
    // print("minutePart is $minutePart");
    var minute = int.tryParse(minutePart) ?? 0;
    // print("minute is $minute");
    return TimeOfDay(hour: hour, minute: minute);
  }
}
