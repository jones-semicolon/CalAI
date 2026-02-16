import 'package:calai/features/reminders/models/nutrition_goals.dart';
import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/services/notification_service.dart';

class SmartNutritionScheduler {
  const SmartNutritionScheduler(this._notificationService);

  final NotificationService _notificationService;

  Future<void> sync({
    required ReminderSettings settings,
    required NutritionGoals goals,
  }) async {
    if (!settings.smartNutritionEnabled) {
      await _notificationService.cancelById(
        ReminderNotificationIds.smartNutritionDaily,
      );
      return;
    }

    final body =
        'Target ${goals.calorieGoal} kcal, ${goals.proteinGoalGrams}g protein, '
        '${goals.carbGoalGrams}g carbs, ${goals.fatGoalGrams}g fat. '
        'Log your latest meal to keep your plan accurate.';

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.smartNutritionDaily,
      title: 'Smart nutrition check-in',
      body: body,
      time: settings.smartNutritionTime,
      payload: 'smart_nutrition:daily',
      highPriority: true,
    );
  }
}
