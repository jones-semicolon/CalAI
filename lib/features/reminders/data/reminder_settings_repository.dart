import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/reminder_settings.dart';

class ReminderSettingsRepository {
  static const _settingsKey = 'reminder_settings_v1';

  Future<ReminderSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null || raw.isEmpty) {
      // First run: persist defaults so future loads always read a full payload.
      final defaults = ReminderSettings.defaults();
      await save(defaults);
      return defaults;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return ReminderSettings.defaults();
    }
    return ReminderSettings.fromJson(decoded);
  }

  Future<void> save(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, raw);
  }
}
