import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/services/notification_service.dart';

import '../../../../models/nutrition_model.dart';

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
        'Target ${goals.calories} kcal, ${goals.protein}g protein, '
        '${goals.carbs}g carbs, ${goals.fats}g fat. '
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
