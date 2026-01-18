import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'alarm_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация временных зон
  tzdata.initializeTimeZones();
  try {
    final String timezone = await FlutterNativeTimezone.getLocalTimezone();
    final loc = tz.getLocation(timezone);
    tz.setLocalLocation(loc);
  } catch (e) {
    // если не удалось получить зону — используем UTC
    final loc = tz.getLocation('Etc/UTC');
    tz.setLocalLocation(loc);
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
    // обработчик нажатия по уведомлению — можно открыть приложение или экран
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Будильник',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AlarmPage(plugin: flutterLocalNotificationsPlugin),
    );
  }
}
