import 'package:calai/features/reminders/models/nutrition_goals.dart';
import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/services/notification_service.dart';
import 'package:calai/features/reminders/services/schedulers/activity_reminder_scheduler.dart';
import 'package:calai/features/reminders/services/schedulers/meal_reminder_scheduler.dart';
import 'package:calai/features/reminders/services/schedulers/smart_nutrition_scheduler.dart';
import 'package:calai/features/reminders/services/schedulers/water_intake_scheduler.dart';

class ReminderScheduler {
  ReminderScheduler(this._notificationService)
    : _smartNutritionScheduler = SmartNutritionScheduler(_notificationService),
      _waterIntakeScheduler = WaterIntakeScheduler(_notificationService),
      _mealReminderScheduler = MealReminderScheduler(_notificationService),
      _activityReminderScheduler = ActivityReminderScheduler(
        _notificationService,
      );

  final NotificationService _notificationService;
  final SmartNutritionScheduler _smartNutritionScheduler;
  final WaterIntakeScheduler _waterIntakeScheduler;
  final MealReminderScheduler _mealReminderScheduler;
  final ActivityReminderScheduler _activityReminderScheduler;

  Future<void> syncAll({
    required ReminderSettings settings,
    required NutritionGoals goals,
  }) async {
    await _smartNutritionScheduler.sync(settings: settings, goals: goals);
    await _waterIntakeScheduler.sync(settings);
    await _mealReminderScheduler.sync(settings);
    await _activityReminderScheduler.sync(settings);
  }

  Future<void> cancelAll() => _notificationService.cancelAll();
}
