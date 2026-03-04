import 'package:calai/l10n/app_localizations.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:calai/onboarding/app_entry.dart';
import 'package:calai/widgets/debug/debug_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calai/theme/app_theme.dart';
import 'package:calai/theme/theme_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:calai/providers/shared_prefs_provider.dart';
import 'package:calai/providers/locale_provider.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      setState(() => _themeMode = mode);
    }
  }

  @override
  Widget build(BuildContext context) {
        return Consumer(
      builder: (context, ref, _) {
        final locale = ref.watch(localeProvider);

        return MaterialApp(
          key: ValueKey<String>(locale?.languageCode ?? 'system'),
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          themeMode: _themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          onGenerateTitle: (context) => context.l10n.appTitle,

          // ✅ GLOBAL OVERLAY INJECTION
          builder: (context, child) {
            // We wrap the entire app in a Stack
            return Stack(
              children: [
                // 1. The actual screen (AppEntry, Dashboard, etc.)
                if (child != null) child,

                // 2. The Debug Overlay (Only show in Debug Mode)
                if (kDebugMode)
                  const Positioned(
                    right: 0,
                    top: 100, // Adjust start position so it doesn't block AppBar
                    child: DebugOverlay(),
                  ),
              ],
            );
          },

          home: const AppEntry(),
        );
      }
    );
  }
}