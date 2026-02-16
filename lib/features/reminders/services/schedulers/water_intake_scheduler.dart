import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/services/notification_service.dart';

class WaterIntakeScheduler {
  const WaterIntakeScheduler(this._notificationService);

  final NotificationService _notificationService;
  static const int _maxDailyWaterReminders = 24;

  Future<void> sync(ReminderSettings settings) async {
    await _clearAllWaterSchedules();
    if (!settings.waterRemindersEnabled) {
      return;
    }

    final times = settings.buildWaterReminderTimes();
    for (var index = 0; index < times.length; index++) {
      await _notificationService.scheduleDailyReminder(
        notificationId: ReminderNotificationIds.waterReminderBase + index,
        title: 'Water reminder',
        body: 'Hydration check. Log a glass of water in Cal AI.',
        time: times[index],
        payload: 'water:$index',
        highPriority: true,
      );
    }
  }

  Future<void> _clearAllWaterSchedules() async {
    final ids = List<int>.generate(
      _maxDailyWaterReminders,
      (index) => ReminderNotificationIds.waterReminderBase + index,
    );
    await _notificationService.cancelByIds(ids);
  }
}
