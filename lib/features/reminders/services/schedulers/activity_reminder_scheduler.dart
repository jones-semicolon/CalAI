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

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.activity,
      title: 'Steps and exercise reminder',
      body: 'Log your steps or workout to complete today\'s activity target.',
      time: settings.activityReminderTime,
      payload: 'activity:daily',
      highPriority: true,
    );
  }
}
