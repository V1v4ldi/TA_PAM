import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


Future<void> initNotifications() async {
  // Inisialisasi untuk Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Request permission khusus Android 13+
  if (Platform.isAndroid) {
    final bool? granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    print('Notification permission granted? $granted');
  }
}


Future<void> showNotif(String title, String body) async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'bookmark_channel', 
        'Bookmark Channel',
        importance: Importance.high,
        priority: Priority.high,
      );

  const NotificationDetails notifDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,      // ID notif (boleh 0)
    title,  // Judul notif
    body,   // Isi notif
    notifDetails,
  );
}