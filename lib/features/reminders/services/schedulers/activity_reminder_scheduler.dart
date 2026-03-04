import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/services/notification_service.dart';

class ActivityReminderScheduler {
  const ActivityReminderScheduler(this._notificationService);

  final NotificationService _notificationService;

  Future<void> sync(ReminderSettings settings) async {
    if (!settings.activityReminderEnabled) {
      await _notificationService.cancelById(ReminderNotificationIds.activity);
      return;
    }
    final l10n = await _notificationService.loadL10n();

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.activity,
      title: l10n.notificationStepsExerciseTitle,
      body: l10n.notificationStepsExerciseBody,
      time: settings.activityReminderTime,
      payload: 'activity:daily',
      highPriority: true,
    );
  }
}
