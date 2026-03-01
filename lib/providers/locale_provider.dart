import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'health_provider.dart';

const String _localePreferenceKey = 'app_locale';

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final code = prefs.getString(_localePreferenceKey);
    if (code == null || code.isEmpty) {
      return null;
    }
    return Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(_localePreferenceKey);
      return;
    }
    await prefs.setString(_localePreferenceKey, locale.languageCode);
  }
}
