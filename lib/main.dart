import 'package:calai/l10n/app_localizations.dart';
import 'package:calai/data/global_data.dart';
import 'package:calai/features/reminders/reminders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/theme_service.dart';
import 'theme/app_theme.dart';
import './onboarding/app_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeService = ThemeService();
  final savedTheme = await themeService.loadTheme();

  ThemeMode initialThemeMode;
  if (savedTheme == "Light") {
    initialThemeMode = ThemeMode.light;
  } else if (savedTheme == "Dark") {
    initialThemeMode = ThemeMode.dark;
  } else {
    initialThemeMode = ThemeMode.system;
  }

  final prefs = await SharedPreferences.getInstance();
  final savedLanguageCode = prefs.getString('language_code') ?? 'us';
  if (!prefs.containsKey('language_code')) {
    await prefs.setString('language_code', savedLanguageCode);
  }
  final initialLocale = MyApp.localeFromCode(savedLanguageCode);

  runApp(
    ProviderScope(
      child: MyApp(
        initialThemeMode: initialThemeMode,
        initialLocale: initialLocale,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  final Locale? initialLocale;

  const MyApp({
    super.key,
    this.initialThemeMode = ThemeMode.light,
    this.initialLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  static Locale? localeFromCode(String? code) {
    switch (code) {
      case 'us':
      case 'en':
        return const Locale('en');
      case 'es':
        return const Locale('es');
      case 'pt':
        return const Locale('pt');
      case 'fr':
        return const Locale('fr');
      case 'de':
        return const Locale('de');
      case 'it':
        return const Locale('it');
      case 'hi':
        return const Locale('hi');
      default:
        return null;
    }
  }
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  Locale? _locale;
  DateTime? _lastReminderSyncDay;
  bool _isReminderSyncInProgress = false;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _locale = widget.initialLocale;
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncRemindersIfNeeded();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  late final WidgetsBindingObserver _lifecycleObserver =
      _ReminderLifecycleObserver(onResume: _syncRemindersIfNeeded);

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void setLocale(Locale? locale) {
    setState(() => _locale = locale);
  }

  Future<void> _syncRemindersIfNeeded() async {
    if (_isReminderSyncInProgress) {
      return;
    }

    final now = DateTime.now();
    if (_lastReminderSyncDay != null &&
        _isSameDay(_lastReminderSyncDay!, now)) {
      return;
    }

    _isReminderSyncInProgress = true;
    try {
      final goals = GlobalData();
      await ReminderBootstrap.initializeIfNeeded(
        goals: NutritionGoals(
          calorieGoal: goals.caloriesADay,
          proteinGoalGrams: goals.proteinADay,
          carbGoalGrams: goals.carbsADay,
          fatGoalGrams: goals.fatsADay,
        ),
      );
      _lastReminderSyncDay = now;
    } finally {
      _isReminderSyncInProgress = false;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal AI - Calorie Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppEntry(),
    );
  }
}

class _ReminderLifecycleObserver extends WidgetsBindingObserver {
  _ReminderLifecycleObserver({required this.onResume});

  final Future<void> Function() onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
