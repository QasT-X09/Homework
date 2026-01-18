import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin plugin;
  const AlarmPage({super.key, required this.plugin});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final List<tz.TZDateTime> _alarms = [];
  int _nextId = 0;

  Future<void> _scheduleAlarm(TimeOfDay time) async {
    final tz.TZDateTime scheduled = _nextInstanceOfTime(time);
    final id = _nextId++;

    await widget.plugin.zonedSchedule(
      id,
      'Будильник',
      'Пора просыпаться',
      scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Будильник',
          channelDescription: 'Канал для будильников',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    setState(() {
      _alarms.add(scheduled);
    });
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> _pickTimeAndSchedule() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      await _scheduleAlarm(picked);
    }
  }

  String _formatTZDate(tz.TZDateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.day}.${dt.month}.${dt.year}';
  }

  Future<void> _cancelAll() async {
    await widget.plugin.cancelAll();
    setState(() => _alarms.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Будильник')),
      body: Column(
        children: [
          Expanded(
            child: _alarms.isEmpty
                ? const Center(child: Text('Список будильников пуст'))
                : ListView.builder(
                    itemCount: _alarms.length,
                    itemBuilder: (context, index) {
                      final a = _alarms[index];
                      return ListTile(
                        title: Text(_formatTZDate(a)),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickTimeAndSchedule,
                    child: const Text('Добавить'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _cancelAll,
                  child: const Text('Отменить все'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
