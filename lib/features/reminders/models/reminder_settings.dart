import 'package:flutter/material.dart';

class ReminderSettings {
  const ReminderSettings({
    required this.waterRemindersEnabled,
    required this.waterReminderIntervalHours,
    required this.waterReminderStartTime,
    required this.breakfastReminderEnabled,
    required this.breakfastReminderTime,
    required this.lunchReminderEnabled,
    required this.lunchReminderTime,
    required this.dinnerReminderEnabled,
    required this.dinnerReminderTime,
    required this.snackReminderEnabled,
    required this.snackReminderTime,
    required this.goalTrackingAlertsEnabled,
    required this.activityReminderEnabled,
    required this.activityReminderTime,
  });

  final bool waterRemindersEnabled;
  final int waterReminderIntervalHours;
  final TimeOfDay waterReminderStartTime;

  final bool breakfastReminderEnabled;
  final TimeOfDay breakfastReminderTime;
  final bool lunchReminderEnabled;
  final TimeOfDay lunchReminderTime;
  final bool dinnerReminderEnabled;
  final TimeOfDay dinnerReminderTime;
  final bool snackReminderEnabled;
  final TimeOfDay snackReminderTime;

  final bool goalTrackingAlertsEnabled;

  final bool activityReminderEnabled;
  final TimeOfDay activityReminderTime;

  static ReminderSettings defaults() {
    return const ReminderSettings(
      waterRemindersEnabled: true,
      waterReminderIntervalHours: 2,
      waterReminderStartTime: TimeOfDay(hour: 8, minute: 0),
      breakfastReminderEnabled: true,
      breakfastReminderTime: TimeOfDay(hour: 8, minute: 0),
      lunchReminderEnabled: true,
      lunchReminderTime: TimeOfDay(hour: 12, minute: 30),
      dinnerReminderEnabled: true,
      dinnerReminderTime: TimeOfDay(hour: 19, minute: 0),
      snackReminderEnabled: true,
      snackReminderTime: TimeOfDay(hour: 15, minute: 30),
      goalTrackingAlertsEnabled: true,
      activityReminderEnabled: true,
      activityReminderTime: TimeOfDay(hour: 20, minute: 0),
    );
  }

  ReminderSettings copyWith({
    bool? smartNutritionEnabled,
    TimeOfDay? smartNutritionTime,
    bool? waterRemindersEnabled,
    int? waterReminderIntervalHours,
    TimeOfDay? waterReminderStartTime,
    bool? breakfastReminderEnabled,
    TimeOfDay? breakfastReminderTime,
    bool? lunchReminderEnabled,
    TimeOfDay? lunchReminderTime,
    bool? dinnerReminderEnabled,
    TimeOfDay? dinnerReminderTime,
    bool? snackReminderEnabled,
    TimeOfDay? snackReminderTime,
    bool? goalTrackingAlertsEnabled,
    bool? activityReminderEnabled,
    TimeOfDay? activityReminderTime,
  }) {
    return ReminderSettings(
      waterRemindersEnabled:
          waterRemindersEnabled ?? this.waterRemindersEnabled,
      waterReminderIntervalHours:
          waterReminderIntervalHours ?? this.waterReminderIntervalHours,
      waterReminderStartTime:
          waterReminderStartTime ?? this.waterReminderStartTime,
      breakfastReminderEnabled:
          breakfastReminderEnabled ?? this.breakfastReminderEnabled,
      breakfastReminderTime:
          breakfastReminderTime ?? this.breakfastReminderTime,
      lunchReminderEnabled: lunchReminderEnabled ?? this.lunchReminderEnabled,
      lunchReminderTime: lunchReminderTime ?? this.lunchReminderTime,
      dinnerReminderEnabled:
          dinnerReminderEnabled ?? this.dinnerReminderEnabled,
      dinnerReminderTime: dinnerReminderTime ?? this.dinnerReminderTime,
      snackReminderEnabled: snackReminderEnabled ?? this.snackReminderEnabled,
      snackReminderTime: snackReminderTime ?? this.snackReminderTime,
      goalTrackingAlertsEnabled:
          goalTrackingAlertsEnabled ?? this.goalTrackingAlertsEnabled,
      activityReminderEnabled:
          activityReminderEnabled ?? this.activityReminderEnabled,
      activityReminderTime: activityReminderTime ?? this.activityReminderTime,
    );
  }

  List<TimeOfDay> buildWaterReminderTimes() {
    final interval = waterReminderIntervalHours.clamp(1, 12);
    final startMinutes = _toMinutes(waterReminderStartTime);
    final times = <TimeOfDay>[];

    var current = startMinutes;
    // Build reminder slots from the start time until end of day.
    while (current < 24 * 60) {
      times.add(_fromMinutes(current));
      current += interval * 60;
    }
    return times;
  }

  Map<String, Object> toJson() {
    return {
      'waterRemindersEnabled': waterRemindersEnabled,
      'waterReminderIntervalHours': waterReminderIntervalHours,
      'waterReminderStartTime': _toMinutes(waterReminderStartTime),
      'breakfastReminderEnabled': breakfastReminderEnabled,
      'breakfastReminderTime': _toMinutes(breakfastReminderTime),
      'lunchReminderEnabled': lunchReminderEnabled,
      'lunchReminderTime': _toMinutes(lunchReminderTime),
      'dinnerReminderEnabled': dinnerReminderEnabled,
      'dinnerReminderTime': _toMinutes(dinnerReminderTime),
      'snackReminderEnabled': snackReminderEnabled,
      'snackReminderTime': _toMinutes(snackReminderTime),
      'goalTrackingAlertsEnabled': goalTrackingAlertsEnabled,
      'activityReminderEnabled': activityReminderEnabled,
      'activityReminderTime': _toMinutes(activityReminderTime),
    };
  }

  factory ReminderSettings.fromJson(Map<String, dynamic> json) {
    final defaults = ReminderSettings.defaults();
    return ReminderSettings(
      waterRemindersEnabled:
          json['waterRemindersEnabled'] as bool? ??
          defaults.waterRemindersEnabled,
      waterReminderIntervalHours:
          (json['waterReminderIntervalHours'] as int?) ??
          defaults.waterReminderIntervalHours,
      waterReminderStartTime: _fromMinutes(
        json['waterReminderStartTime'] as int? ??
            _toMinutes(defaults.waterReminderStartTime),
      ),
      breakfastReminderEnabled:
          json['breakfastReminderEnabled'] as bool? ??
          defaults.breakfastReminderEnabled,
      breakfastReminderTime: _fromMinutes(
        json['breakfastReminderTime'] as int? ??
            _toMinutes(defaults.breakfastReminderTime),
      ),
      lunchReminderEnabled:
          json['lunchReminderEnabled'] as bool? ??
          defaults.lunchReminderEnabled,
      lunchReminderTime: _fromMinutes(
        json['lunchReminderTime'] as int? ??
            _toMinutes(defaults.lunchReminderTime),
      ),
      dinnerReminderEnabled:
          json['dinnerReminderEnabled'] as bool? ??
          defaults.dinnerReminderEnabled,
      dinnerReminderTime: _fromMinutes(
        json['dinnerReminderTime'] as int? ??
            _toMinutes(defaults.dinnerReminderTime),
      ),
      snackReminderEnabled:
          json['snackReminderEnabled'] as bool? ??
          defaults.snackReminderEnabled,
      snackReminderTime: _fromMinutes(
        json['snackReminderTime'] as int? ??
            _toMinutes(defaults.snackReminderTime),
      ),
      goalTrackingAlertsEnabled:
          json['goalTrackingAlertsEnabled'] as bool? ??
          defaults.goalTrackingAlertsEnabled,
      activityReminderEnabled:
          json['activityReminderEnabled'] as bool? ??
          defaults.activityReminderEnabled,
      activityReminderTime: _fromMinutes(
        json['activityReminderTime'] as int? ??
            _toMinutes(defaults.activityReminderTime),
      ),
    );
  }

  static int _toMinutes(TimeOfDay value) => value.hour * 60 + value.minute;

  static TimeOfDay _fromMinutes(int minutes) {
    // Normalize so old/surprising saved values still map into a valid 24h clock.
    final normalized = minutes % (24 * 60);
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }
}
