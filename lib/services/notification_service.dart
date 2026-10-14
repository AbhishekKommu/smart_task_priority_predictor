import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../models/task_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  final _player = AudioPlayer();
  final Map<String, Timer> _timers = {};

  /// Called when a reminder fires while the app is open.
  void Function(TaskModel task)? onReminder;

  bool get _native =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    if (!_native) return;
    tzdata.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  int _nid(String id) => id.hashCode & 0x7fffffff;

  Future<void> schedule(TaskModel t) async {
    await cancel(t.id);
    final r = t.reminder;
    if (r == null || t.completed || !r.isAfter(DateTime.now())) return;

    // Works on web and whenever the app is open
    _timers[t.id] = Timer(r.difference(DateTime.now()), () {
      playAlarm();
      onReminder?.call(t);
    });

    // Works on Android/iOS even when the app is closed
    if (_native) {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task reminders',
          channelDescription: 'Sound alerts for your tasks',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(presentSound: true),
      );
      await _plugin.zonedSchedule(
        _nid(t.id),
        '⏰ ${t.title}',
        'Time to work on your task!',
        tz.TZDateTime.from(r, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancel(String taskId) async {
    _timers.remove(taskId)?.cancel();
    if (_native) await _plugin.cancel(_nid(taskId));
  }

  Future<void> playAlarm() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('sounds/alarm.wav'));
    } catch (_) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  Future<void> stopAlarm() async {
    try {
      await _player.stop();
    } catch (_) {}
  }
}
