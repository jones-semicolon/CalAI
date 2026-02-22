import 'package:calai/features/reminders/data/reminder_settings_repository.dart';
import 'package:calai/features/reminders/models/nutrition_intake_snapshot.dart';
import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/services/notification_service.dart';
import 'package:calai/features/reminders/services/reminder_scheduler.dart';
import 'package:calai/models/nutrition_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../providers/global_provider.dart';

final reminderSettingsRepositoryProvider = Provider<ReminderSettingsRepository>(
  (ref) => ReminderSettingsRepository(),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => ReminderScheduler(ref.read(notificationServiceProvider)),
);

final reminderSettingsControllerProvider =
    AsyncNotifierProvider<ReminderSettingsController, ReminderSettings>(
      ReminderSettingsController.new,
    );

class DinnerScheduleDebugInfo {
  const DinnerScheduleDebugInfo({
    required this.nextDinnerAt,
    required this.pendingDinnerScheduleCount,
    required this.expectedPendingCount,
  });

  final tz.TZDateTime nextDinnerAt;
  final int pendingDinnerScheduleCount;
  final int expectedPendingCount;
}

class ReminderSettingsController extends AsyncNotifier<ReminderSettings> {
  ReminderSettingsRepository get _repository =>
      ref.read(reminderSettingsRepositoryProvider);
  NotificationService get _notificationService =>
      ref.read(notificationServiceProvider);
  ReminderScheduler get _scheduler => ref.read(reminderSchedulerProvider);
  bool _notificationRuntimeReady = false;

  @override
  Future<ReminderSettings> build() async {
    return _repository.load();
  }

  Future<void> initializeNotifications() async {
    final current = await future;
    final goals = ref.read(globalDataProvider).value?.todayGoal;
    await _notificationService.initialize();
    await _scheduler.syncAll(settings: current, goals: goals ?? NutritionGoals.empty);
  }

  Future<void> saveAndReschedule(ReminderSettings settings) async {
    // Update UI immediately so toggles/time labels feel responsive.
    state = AsyncData(settings);
    await _repository.save(settings);
    final goals = ref.read(globalDataProvider).value?.todayGoal;
    await _notificationService.initialize();
    await _scheduler.syncAll(settings: settings, goals: goals ?? NutritionGoals.empty);
  }

  Future<void> toggleSmartNutrition(bool enabled) async {
    final current = await future;
    final ready = await _ensurePermissionForToggle(
      currentValue: current.smartNutritionEnabled,
      nextValue: enabled,
    );
    if (!ready) {
      return;
    }
    await saveAndReschedule(current.copyWith(smartNutritionEnabled: enabled));
  }

  Future<void> setSmartNutritionTime(TimeOfDay value) async {
    final current = await future;
    await saveAndReschedule(current.copyWith(smartNutritionTime: value));
  }

  Future<void> toggleWaterReminders(bool enabled) async {
    final current = await future;
    final ready = await _ensurePermissionForToggle(
      currentValue: current.waterRemindersEnabled,
      nextValue: enabled,
    );
    if (!ready) {
      return;
    }
    await saveAndReschedule(current.copyWith(waterRemindersEnabled: enabled));
  }

  Future<void> setWaterIntervalHours(int intervalHours) async {
    final current = await future;
    await saveAndReschedule(
      current.copyWith(waterReminderIntervalHours: intervalHours),
    );
  }

  Future<void> setWaterStartTime(TimeOfDay value) async {
    final current = await future;
    await saveAndReschedule(current.copyWith(waterReminderStartTime: value));
  }

  Future<void> toggleBreakfast(bool enabled) async {
    final current = await future;
    final ready = await _ensurePermissionForToggle(
      currentValue: current.breakfastReminderEnabled,
      nextValue: enabled,
    );
    if (!ready) {
      return;
    }
    await saveAndReschedule(
      current.copyWith(breakfastReminderEnabled: enabled),
    );
  }

  Future<void> setBreakfastTime(TimeOfDay value) async {
    final current = await future;
    await saveAndReschedule(current.copyWith(breakfastReminderTime: value));
  }

  Future<void> toggleLunch(bool enabled) async {
    final current = await future;
    final ready = await _ensurePermissionForToggle(
      currentValue: current.lunchReminderEnabled,
      nextValue: enabled,
    );
    if (!ready) {
      return;
    }
    await saveAndReschedule(current.copyWith(lunchReminderEnabled: enabled));
  }

  Future<void> setLunchTime(TimeOfDay value) async {
    final current = await future;
    await saveAndReschedule(current.copyWith(lunchReminderTime: value));
  }

  Future<void> toggleDinner(bool enabled) async {
    final current = await future;
    final ready = await _ensurePermissionForToggle(
      currentValue: current.dinnerReminderEnabled,
      nextValue: enabled,
    );
    if (!ready) {
      return;
    }
    await saveAndReschedule(current.copyWith(dinnerReminderEnabled: enabled));
  }

  Future<void> setDinnerTime(TimeOfDay value) async {
    final current = await future;
    await saveAndReschedule(current.copyWith(dinnerReminderTime: value));
  }

  Future<void> toggleSnack(bool enabled) async {
    final current = await future;
    final ready = await _ensurePermissionForToggle(
      currentValue: current.snackReminderEnabled,
      nextValue: enabled,
    );
    if (!ready) {
      return;
    }
    await saveAndReschedule(current.copyWith(snackReminderEnabled: enabled));
  }

  Future<void> setSnackTime(TimeOfDay value) async {
    final current = await future;
    await saveAndReschedule(current.copyWith(snackReminderTime: value));
  }

  Future<void> toggleGoalTrackingAlerts(bool enabled) async {
    final current = await future;
    final ready = await _ensurePermissionForToggle(
      currentValue: current.goalTrackingAlertsEnabled,
      nextValue: enabled,
    );
    if (!ready) {
      return;
    }
    await saveAndReschedule(
      current.copyWith(goalTrackingAlertsEnabled: enabled),
    );
  }

  Future<void> toggleActivityReminder(bool enabled) async {
    final current = await future;
    final ready = await _ensurePermissionForToggle(
      currentValue: current.activityReminderEnabled,
      nextValue: enabled,
    );
    if (!ready) {
      return;
    }
    await saveAndReschedule(current.copyWith(activityReminderEnabled: enabled));
  }

  Future<void> setActivityReminderTime(TimeOfDay value) async {
    final current = await future;
    await saveAndReschedule(current.copyWith(activityReminderTime: value));
  }

  Future<void> maybeTriggerGoalAlerts(NutritionIntakeSnapshot snapshot) async {
    final current = await future;
    if (!current.goalTrackingAlertsEnabled) {
      return;
    }
    final hasPermission = await _notificationService
        .hasNotificationPermission();
    if (!hasPermission) {
      return;
    }
    await _notificationService.triggerGoalBasedAlerts(snapshot);
  }

  Future<DinnerScheduleDebugInfo> getDinnerScheduleDebugInfo(
    ReminderSettings settings,
  ) async {
    await _notificationService.initialize();
    final nextDinnerAt = _notificationService.previewNextDailyScheduleTime(
      settings.dinnerReminderTime,
    );
    final pendingCount = await _notificationService
        .countPendingForDailyReminder(ReminderNotificationIds.dinner);
    return DinnerScheduleDebugInfo(
      nextDinnerAt: nextDinnerAt,
      pendingDinnerScheduleCount: pendingCount,
      expectedPendingCount: settings.dinnerReminderEnabled
          ? _notificationService.expectedDailyScheduleCount()
          : 0,
    );
  }

  Future<bool> _ensurePermissionForToggle({
    required bool currentValue,
    required bool nextValue,
  }) async {
    if (!nextValue || currentValue) {
      return true;
    }

    if (_notificationRuntimeReady) {
      return true;
    }

    final granted = await _notificationService.requestPermissions();
    _notificationRuntimeReady = granted;
    return granted;
  }
}
