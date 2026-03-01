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
    final l10n = await _notificationService.loadL10n();

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.breakfast,
      title: l10n.notificationBreakfastTitle,
      body: l10n.notificationBreakfastBody,
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
    final l10n = await _notificationService.loadL10n();

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.lunch,
      title: l10n.notificationLunchTitle,
      body: l10n.notificationLunchBody,
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
    final l10n = await _notificationService.loadL10n();

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.dinner,
      title: l10n.notificationDinnerTitle,
      body: l10n.notificationDinnerBody,
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
    final l10n = await _notificationService.loadL10n();

    await _notificationService.scheduleDailyReminder(
      notificationId: ReminderNotificationIds.snack,
      title: l10n.notificationSnackTitle,
      body: l10n.notificationSnackBody,
      time: settings.snackReminderTime,
      payload: 'meal:snack',
      highPriority: true,
    );
  }
}
