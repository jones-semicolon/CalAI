import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/services/notification_service.dart';

class MealReminderScheduler {
  const MealReminderScheduler(this._notificationService);

  final NotificationService _notificationService;

  Future<void> sync(ReminderSettings settings) async {
    await _syncBreakfast(settings);
    await _syncLunch(settings);
    await _syncDinner(settings);
    await _syncSnack(settings);
  }

  Future<void> _syncBreakfast(ReminderSettings settings) async {
    if (!settings.breakfastReminderEnabled) {
      await _notificationService.cancelById(ReminderNotificationIds.breakfast);
      return;
    }

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.breakfast,
      title: 'Breakfast reminder',
      body: 'Log breakfast to start your calorie and macro tracking early.',
      time: settings.breakfastReminderTime,
      payload: 'meal:breakfast',
      highPriority: true,
    );
  }

  Future<void> _syncLunch(ReminderSettings settings) async {
    if (!settings.lunchReminderEnabled) {
      await _notificationService.cancelById(ReminderNotificationIds.lunch);
      return;
    }

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.lunch,
      title: 'Lunch reminder',
      body: 'Lunch time. Add your meal to keep your daily progress accurate.',
      time: settings.lunchReminderTime,
      payload: 'meal:lunch',
      highPriority: true,
    );
  }

  Future<void> _syncDinner(ReminderSettings settings) async {
    if (!settings.dinnerReminderEnabled) {
      await _notificationService.cancelById(ReminderNotificationIds.dinner);
      return;
    }

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.dinner,
      title: 'Dinner reminder',
      body: 'Log dinner and close your day with complete nutrition data.',
      time: settings.dinnerReminderTime,
      payload: 'meal:dinner',
      highPriority: true,
    );
  }

  Future<void> _syncSnack(ReminderSettings settings) async {
    if (!settings.snackReminderEnabled) {
      await _notificationService.cancelById(ReminderNotificationIds.snack);
      return;
    }

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.snack,
      title: 'Snack reminder',
      body:
          'Add your snack so calories and macros stay aligned with your goals.',
      time: settings.snackReminderTime,
      payload: 'meal:snack',
      highPriority: true,
    );
  }
}
