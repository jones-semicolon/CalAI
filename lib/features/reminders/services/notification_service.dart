import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/goal_alert.dart';
import '../models/nutrition_intake_snapshot.dart';
import 'goal_alert_evaluator.dart';

class ReminderNotificationIds {
  // Keep these ID ranges stable so old scheduled IDs can still be cancelled.
  static const int smartNutritionDaily = 1000;
  static const int waterReminderBase = 1100;
  static const int breakfast = 1200;
  static const int lunch = 1201;
  static const int dinner = 1202;
  static const int snack = 1203;
  static const int activity = 1300;
  static const int smartNutritionContextual = 1500;
  static const int goalAlertBase = 1600;
}

class NotificationService {
  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    GoalAlertEvaluator? goalAlertEvaluator,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _goalAlertEvaluator = goalAlertEvaluator ?? const GoalAlertEvaluator();

  final FlutterLocalNotificationsPlugin _plugin;
  final GoalAlertEvaluator _goalAlertEvaluator;

  static const AndroidNotificationChannel _remindersChannel =
      AndroidNotificationChannel(
        'calai_reminders_v3',
        'Cal AI Reminders',
        description: 'Meal, water, nutrition, and activity reminders',
        importance: Importance.max,
      );

  static const AndroidNotificationChannel _goalAlertsChannel =
      AndroidNotificationChannel(
        'calai_goal_alerts',
        'Cal AI Goal Alerts',
        description: 'High-priority alerts when nutrition goals are at risk',
        importance: Importance.high,
      );

  static const _goalAlertLastSentPrefix = 'goal_alert_last_sent_';
  static const int _legacyDailyScheduleWindowDays = 14;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();
    await _configureLocalTimeZone();

    const androidInitSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosInitSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _plugin.initialize(initSettings);
    await _createAndroidChannels();
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    await initialize();

    var iosGranted = true;
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosResult = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (iosResult != null) {
      iosGranted = iosResult;
    }

    var androidGranted = true;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();
    final androidEnabled = await android?.areNotificationsEnabled();
    if (androidEnabled != null) {
      androidGranted = androidEnabled;
    }

    return iosGranted && androidGranted;
  }

  Future<bool> hasNotificationPermission() async {
    await initialize();

    var iosGranted = true;
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosPermissions = await ios?.checkPermissions();
    if (iosPermissions != null) {
      iosGranted = iosPermissions.isEnabled;
    }

    var androidGranted = true;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidEnabled = await android?.areNotificationsEnabled();
    if (androidEnabled != null) {
      androidGranted = androidEnabled;
    }

    return iosGranted && androidGranted;
  }

  Future<void> scheduleDailyReminder({
    required int notificationId,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
    bool highPriority = false,
  }) async {
    await initialize();
    // Time zone can change while app stays installed (travel/DST), so refresh before schedule.
    await _configureLocalTimeZone();
    await cancelById(notificationId);

    // Use a single repeating inexact schedule for reliability on Android 14/15
    // without requiring exact alarm permissions.
    final firstOccurrence = _nextInstanceOf(time);
    await _scheduleRepeatingDaily(
      notificationId: notificationId,
      title: title,
      body: body,
      scheduledAt: firstOccurrence,
      payload: payload,
      highPriority: highPriority,
    );
  }

  Future<void> showGoalAlert(GoalAlert alert) async {
    await initialize();
    final id = ReminderNotificationIds.goalAlertBase + alert.type.index;
    await _plugin.show(
      id,
      alert.title,
      alert.body,
      _details(highPriority: true, useGoalAlertsChannel: true),
      payload: 'goal:${alert.type.name}',
    );
  }

  Future<void> showSmartNutritionNudge(NutritionIntakeSnapshot snapshot) async {
    await initialize();
    final body = _smartNutritionBody(snapshot);
    await _plugin.show(
      ReminderNotificationIds.smartNutritionContextual,
      'Smart nutrition tip',
      body,
      _details(),
      payload: 'smart_nutrition:nudge',
    );
  }

  Future<void> triggerGoalBasedAlerts(
    NutritionIntakeSnapshot snapshot, {
    bool avoidDuplicateAlertsInSameDay = true,
  }) async {
    await initialize();
    final alerts = _goalAlertEvaluator.evaluate(snapshot);
    if (alerts.isEmpty) {
      return;
    }

    final todayKey = _dateKey(DateTime.now());
    final prefs = await SharedPreferences.getInstance();

    for (final alert in alerts) {
      final key = '$_goalAlertLastSentPrefix${alert.type.name}';
      // Avoid spamming the same alert type over and over in one day.
      if (avoidDuplicateAlertsInSameDay && prefs.getString(key) == todayKey) {
        continue;
      }

      await showGoalAlert(alert);
      if (avoidDuplicateAlertsInSameDay) {
        await prefs.setString(key, todayKey);
      }
    }
  }

  Future<void> cancelById(int id) async {
    await _plugin.cancel(id);
    // Cleanup previously scheduled one-shot IDs from old app versions.
    for (
      var dayOffset = 0;
      dayOffset < _legacyDailyScheduleWindowDays;
      dayOffset++
    ) {
      await _plugin.cancel(_dailyInstanceId(id, dayOffset));
    }
  }

  Future<void> cancelByIds(Iterable<int> ids) async {
    for (final id in ids) {
      await cancelById(id);
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<int> countPendingForDailyReminder(int id) async {
    await initialize();
    final pending = await _plugin.pendingNotificationRequests();
    final validIds = <int>{id}; // Current repeating ID.
    for (
      var dayOffset = 0;
      dayOffset < _legacyDailyScheduleWindowDays;
      dayOffset++
    ) {
      validIds.add(_dailyInstanceId(id, dayOffset)); // Legacy one-shot IDs.
    }
    return pending.where((request) => validIds.contains(request.id)).length;
  }

  tz.TZDateTime previewNextDailyScheduleTime(TimeOfDay time) {
    return _nextInstanceOf(time);
  }

  int expectedDailyScheduleCount() => 1;

  NotificationDetails _details({
    bool highPriority = false,
    bool useGoalAlertsChannel = false,
  }) {
    final channel = useGoalAlertsChannel
        ? _goalAlertsChannel
        : _remindersChannel;
    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: highPriority ? Importance.max : Importance.high,
      priority: highPriority ? Priority.max : Priority.high,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
      playSound: true,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: highPriority
          ? InterruptionLevel.timeSensitive
          : InterruptionLevel.active,
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  tz.TZDateTime _nextInstanceOf(TimeOfDay time) {
    final now = tz.TZDateTime.from(DateTime.now(), tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> _scheduleRepeatingDaily({
    required int notificationId,
    required String title,
    required String body,
    required tz.TZDateTime scheduledAt,
    required bool highPriority,
    String? payload,
  }) async {
    // `DateTimeComponents.time` means "repeat every day at this local clock time".
    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledAt,
      _details(highPriority: highPriority),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  int _dailyInstanceId(int baseId, int dayOffset) => baseId * 100 + dayOffset;

  Future<void> _createAndroidChannels() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) {
      return;
    }

    await android.createNotificationChannel(_remindersChannel);
    await android.createNotificationChannel(_goalAlertsChannel);
  }

  Future<void> _configureLocalTimeZone() async {
    final deviceNow = DateTime.now();
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(_resolveLocation(timezoneName, deviceNow));
    } catch (_) {
      // If device timezone API fails, we still pick a sane fallback to keep scheduling alive.
      tz.setLocalLocation(_fallbackLocation(deviceNow));
    }
  }

  tz.Location _resolveLocation(String timezoneName, DateTime now) {
    final trimmed = timezoneName.trim();
    try {
      return tz.getLocation(trimmed);
    } catch (_) {
      // Some devices return aliases/abbreviations. Fall back by matching offset.
      return _fallbackLocation(now);
    }
  }

  tz.Location _fallbackLocation(DateTime now) {
    final targetOffset = now.timeZoneOffset;
    // Match by current UTC offset as a best-effort fallback when timezone name is unknown.
    for (final location in tz.timeZoneDatabase.locations.values) {
      final candidate = tz.TZDateTime.from(now, location);
      if (candidate.timeZoneOffset == targetOffset) {
        return location;
      }
    }
    return tz.getLocation('UTC');
  }

  static String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _smartNutritionBody(NutritionIntakeSnapshot snapshot) {
    final caloriesRemaining = snapshot.caloriesRemaining;
    final proteinRemaining = snapshot.proteinRemaining;
    final calorieMessage = caloriesRemaining > 0
        ? '$caloriesRemaining kcal left'
        : '${caloriesRemaining.abs()} kcal over';
    final proteinMessage = proteinRemaining > 0
        ? '$proteinRemaining g protein remaining'
        : 'protein goal reached';

    return '$calorieMessage and $proteinMessage. Log your next meal to stay on track.';
  }
}
