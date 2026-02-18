import 'package:calai/features/reminders/models/reminder_settings.dart';
import 'package:calai/features/reminders/presentation/reminder_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderSettingsSection extends ConsumerStatefulWidget {
  const ReminderSettingsSection({super.key});

  @override
  ConsumerState<ReminderSettingsSection> createState() =>
      _ReminderSettingsSectionState();
}

class _ReminderSettingsSectionState
    extends ConsumerState<ReminderSettingsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(reminderSettingsControllerProvider.notifier)
          .initializeNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(reminderSettingsControllerProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 185, 168, 209),
        borderRadius: BorderRadius.circular(20),
      ),
      child: settingsAsync.when(
        data: (settings) => _ReminderSettingsContent(settings: settings),
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Failed to load reminder settings.',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

class _ReminderSettingsContent extends ConsumerWidget {
  const _ReminderSettingsContent({required this.settings});

  final ReminderSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).colorScheme.primary;
    final controller = ref.read(reminderSettingsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                color: textColor,
                size: 26,
              ),
              const SizedBox(width: 12),
              Text(
                'Reminders',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        _divider(context),
        _switchRow(
          context: context,
          title: 'Smart nutrition reminders',
          subtitle:
              'Daily reminder at ${_formatTime(context, settings.smartNutritionTime)}',
          value: settings.smartNutritionEnabled,
          onChanged: controller.toggleSmartNutrition,
        ),
        _timeAction(
          context: context,
          label: 'Set smart nutrition time',
          value: settings.smartNutritionTime,
          onPicked: (value) {
            controller.setSmartNutritionTime(value);
          },
        ),
        _divider(context),
        _switchRow(
          context: context,
          title: 'Water reminders',
          subtitle:
              'Every ${settings.waterReminderIntervalHours} hour(s) from ${_formatTime(context, settings.waterReminderStartTime)}',
          value: settings.waterRemindersEnabled,
          onChanged: controller.toggleWaterReminders,
        ),
        _waterIntervalPicker(context, ref),
        _timeAction(
          context: context,
          label: 'Set water start time',
          value: settings.waterReminderStartTime,
          onPicked: (value) {
            controller.setWaterStartTime(value);
          },
        ),
        _divider(context),
        _mealTile(
          context: context,
          title: 'Breakfast reminder',
          enabled: settings.breakfastReminderEnabled,
          time: settings.breakfastReminderTime,
          onToggle: (value) {
            controller.toggleBreakfast(value);
          },
          onTimePicked: (value) {
            controller.setBreakfastTime(value);
          },
        ),
        _mealTile(
          context: context,
          title: 'Lunch reminder',
          enabled: settings.lunchReminderEnabled,
          time: settings.lunchReminderTime,
          onToggle: (value) {
            controller.toggleLunch(value);
          },
          onTimePicked: (value) {
            controller.setLunchTime(value);
          },
        ),
        _mealTile(
          context: context,
          title: 'Dinner reminder',
          enabled: settings.dinnerReminderEnabled,
          time: settings.dinnerReminderTime,
          onToggle: (value) {
            controller.toggleDinner(value);
          },
          onTimePicked: (value) {
            controller.setDinnerTime(value);
          },
        ),
        _mealTile(
          context: context,
          title: 'Snack reminder',
          enabled: settings.snackReminderEnabled,
          time: settings.snackReminderTime,
          onToggle: (value) {
            controller.toggleSnack(value);
          },
          onTimePicked: (value) {
            controller.setSnackTime(value);
          },
        ),
        _divider(context),
        _switchRow(
          context: context,
          title: 'Goal tracking alerts',
          subtitle: 'Near/exceed calorie and macro goal alerts',
          value: settings.goalTrackingAlertsEnabled,
          onChanged: controller.toggleGoalTrackingAlerts,
        ),
        _switchRow(
          context: context,
          title: 'Steps / exercise reminder',
          subtitle:
              'Daily at ${_formatTime(context, settings.activityReminderTime)}',
          value: settings.activityReminderEnabled,
          onChanged: controller.toggleActivityReminder,
        ),
        _timeAction(
          context: context,
          label: 'Set activity reminder time',
          value: settings.activityReminderTime,
          onPicked: (value) {
            controller.setActivityReminderTime(value);
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _waterIntervalPicker(BuildContext context, WidgetRef ref) {
    final controller = ref.read(reminderSettingsControllerProvider.notifier);
    final textColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text('Interval:', style: _titleStyle(textColor)),
          const SizedBox(width: 12),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: settings.waterReminderIntervalHours.clamp(1, 12),
              dropdownColor: Theme.of(context).dialogTheme.surfaceTintColor,
              borderRadius: BorderRadius.circular(14),
              elevation: 4,
              items: List<DropdownMenuItem<int>>.generate(
                12,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text(
                    '${index + 1} hour(s)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                controller.setWaterIntervalHours(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealTile({
    required BuildContext context,
    required String title,
    required bool enabled,
    required TimeOfDay time,
    required ValueChanged<bool> onToggle,
    required ValueChanged<TimeOfDay> onTimePicked,
  }) {
    return Column(
      children: [
        _switchRow(
          context: context,
          title: title,
          subtitle: _formatTime(context, time),
          value: enabled,
          onChanged: onToggle,
        ),
        _timeAction(
          context: context,
          label: 'Set time',
          value: time,
          onPicked: onTimePicked,
        ),
      ],
    );
  }

  Widget _timeAction({
    required BuildContext context,
    required String label,
    required TimeOfDay value,
    required ValueChanged<TimeOfDay> onPicked,
  }) {
    final textColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: value,
              barrierColor: Colors.black26,
              builder: (context, child) {
                final theme = Theme.of(context);
                final primary = theme.colorScheme.primary;
                final scaffold = theme.scaffoldBackgroundColor;
                return Theme(
                  data: theme.copyWith(
                    timePickerTheme: TimePickerThemeData(
                      backgroundColor: theme.colorScheme.secondary,
                      hourMinuteColor: scaffold,
                      hourMinuteTextColor: primary,
                      hourMinuteTextStyle: TextStyle(
                        color: primary,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                      dayPeriodColor: scaffold,
                      dayPeriodTextColor: primary,
                      dayPeriodTextStyle: TextStyle(
                        color: primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      dialBackgroundColor: theme.colorScheme.surface,
                      dialHandColor: scaffold,
                      dialTextColor: primary,
                      entryModeIconColor: primary,
                      helpTextStyle: TextStyle(
                        color: primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(foregroundColor: primary),
                    ),
                  ),
                  child: child ?? const SizedBox.shrink(),
                );
              },
            );
            if (picked != null) {
              onPicked(picked);
            }
          },
          child: Text(
            '$label (${_formatTime(context, value)})',
            style: _subtitleStyle(textColor),
          ),
        ),
      ),
    );
  }

  Widget _switchRow({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final textColor = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _titleStyle(textColor)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: _subtitleStyle(textColor)),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              thumbColor: MaterialStateProperty.all(Colors.white),
              trackColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.selected)
                    ? Theme.of(context).dialogTheme.barrierColor ??
                    Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary;
              }),
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(Color textColor) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: textColor,
    );
  }

  TextStyle _subtitleStyle(Color textColor) {
    return TextStyle(fontSize: 10, color: textColor);
  }

  String _formatTime(BuildContext context, TimeOfDay value) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(value, alwaysUse24HourFormat: false);
  }

  Widget _divider(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    height: 1,
    color: Theme.of(context).splashColor,
  );
}
