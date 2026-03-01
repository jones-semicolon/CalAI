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
    final l10n = await _notificationService.loadL10n();

    final body = l10n.smartNutritionDailyBody(
      goals.calories,
      goals.protein,
      goals.carbs,
      goals.fats,
    );

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.smartNutritionDaily,
      title: l10n.smartNutritionDailyTitle,
      body: body,
      time: settings.smartNutritionTime,
      payload: 'smart_nutrition:daily',
      highPriority: true,
    );
  }
}
