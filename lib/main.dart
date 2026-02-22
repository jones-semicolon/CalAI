import 'package:calai/l10n/app_localizations.dart';
import 'package:calai/onboarding/app_entry.dart';
import 'package:calai/providers/entry_streams_provider.dart';
import 'package:calai/providers/global_provider.dart';
import 'package:calai/providers/reminder_provider.dart';
import 'package:calai/providers/user_provider.dart';
import 'package:calai/widgets/debug/debug_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calai/theme/app_theme.dart';
import 'package:calai/theme/theme_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:calai/providers/shared_prefs_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Load Local Settings (Theme & Cache)
  final themeService = ThemeService();
  final savedTheme = await themeService.loadTheme();
  final initialThemeMode = _getThemeMode(savedTheme);

  final sharedPrefs = await SharedPreferences.getInstance();

  // 3. Localization Setup
  final savedLanguageCode = sharedPrefs.getString('language_code') ?? 'en';
  final initialLocale = MyApp.localeFromCode(savedLanguageCode);

  runApp(
    ProviderScope(
      overrides: [
        // ✅ CRITICAL: Fixes your "not saving" issue by providing the real instance
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: MyApp(
        initialThemeMode: initialThemeMode,
        initialLocale: initialLocale,
      ),
    ),
  );
}

/// Maps saved string theme to Flutter [ThemeMode]
ThemeMode _getThemeMode(String theme) {
  switch (theme) {
    case 'Light': return ThemeMode.light;
    case 'Dark': return ThemeMode.dark;
    case 'Automatic': return ThemeMode.system;
    default: return ThemeMode.light;
  }
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  final Locale? initialLocale;

  const MyApp({
    super.key,
    required this.initialThemeMode,
    this.initialLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  static Locale? localeFromCode(String? code) {
    final Map<String, Locale> supported = {
      'en': const Locale('en'),
      'us': const Locale('en'),
      'es': const Locale('es'),
      'pt': const Locale('pt'),
      'fr': const Locale('fr'),
      'de': const Locale('de'),
      'it': const Locale('it'),
      'hi': const Locale('hi'),
    };
    return supported[code?.toLowerCase()] ?? const Locale('en');
  }
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _locale = widget.initialLocale;
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      setState(() => _themeMode = mode);
    }
  }

  void setLocale(Locale? locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal AI - Calorie Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Localization
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // ✅ MERGED BUILDER: Handles Debug Overlay & Global Listeners
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, _) {
            ref.listen(userProvider, (previous, next) {
              if (previous != null && previous.id.isNotEmpty && next.id.isEmpty) {
                
                ref.invalidate(globalDataProvider);
                ref.invalidate(dailyEntriesProvider);
                
                debugPrint("Cleanup: User signed out, listeners closed.");
              }
            });

            ref.watch(reminderSyncProvider);

            return Stack(
              children: [
                if (child != null) child,
                if (kDebugMode)
                  const DebugOverlay(),
              ],
            );
          },
        );
      },

      home: const AppEntry(),
    );
  }
}