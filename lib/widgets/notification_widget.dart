import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// #TODO: revise
class NotificationWidget {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future showNotification(
          {var id = 0, var title, var body, var payload}) async =>
      _notifications.show(id, title, body, await notificationDetails());

  static notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id 2', 'channel name',
          sound: RawResourceAndroidNotificationSound('notification'),
          importance: Importance.high),
      iOS: DarwinNotificationDetails(sound: 'notification.mp3'),
    );
  }

  static Future init({bool scheduled = false}) async {
    var initAndroidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = const DarwinInitializationSettings();
    final settings =
        InitializationSettings(android: initAndroidSettings, iOS: ios);
    await _notifications.initialize(settings);
  }
}
