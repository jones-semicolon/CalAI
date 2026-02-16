import 'package:calai/features/reminders/data/reminder_settings_repository.dart';
import 'package:calai/features/reminders/models/nutrition_goals.dart';
import 'package:calai/features/reminders/services/notification_service.dart';
import 'package:calai/features/reminders/services/reminder_scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderBootstrap {
  const ReminderBootstrap._();
  static const _lastSyncDateKey = 'reminder_bootstrap_last_sync_date_v1';

  static Future<void> initialize({required NutritionGoals goals}) async {
    final repository = ReminderSettingsRepository();
    final notificationService = NotificationService();
    final scheduler = ReminderScheduler(notificationService);

    final settings = await repository.load();
    await notificationService.initialize();
    await scheduler.syncAll(settings: settings, goals: goals);
  }

  static Future<bool> initializeIfNeeded({
    required NutritionGoals goals,
    DateTime? now,
  }) async {
    final effectiveNow = now ?? DateTime.now();
    final today = _dateKey(effectiveNow);
    final prefs = await SharedPreferences.getInstance();
    final lastSyncedDate = prefs.getString(_lastSyncDateKey);

    // We only do a full sync once per day to avoid rescheduling every app open.
    if (lastSyncedDate == today) {
      return true;
    }

    final repository = ReminderSettingsRepository();
    final notificationService = NotificationService();
    final scheduler = ReminderScheduler(notificationService);
    await notificationService.initialize();

    final settings = await repository.load();
    await scheduler.syncAll(settings: settings, goals: goals);
    await prefs.setString(_lastSyncDateKey, today);
    return true;
  }

  static String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
