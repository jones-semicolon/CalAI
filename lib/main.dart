import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:calai/data/global_data.dart';
import 'package:calai/pages/shell/widget_tree.dart';
import 'package:calai/theme/app_theme.dart';
import 'package:calai/theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load theme settings before app launch
  final themeService = ThemeService();
  final savedTheme = await themeService.loadTheme();
  final initialThemeMode = _getThemeMode(savedTheme);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GlobalData()..fetchGoals(),
        ),
      ],
      child: MyApp(initialThemeMode: initialThemeMode),
    ),
  );
}

/// Maps saved string theme to Flutter [ThemeMode]
ThemeMode _getThemeMode(String theme) {
  switch (theme) {
    case 'Light':
      return ThemeMode.light;
    case 'Dark':
      return ThemeMode.dark;
    case 'Automatic':
      return ThemeMode.system;
    default:
      return ThemeMode.light;
  }
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();

  /// Static helper to access theme switching logic from child widgets
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  /// Sets the application's theme mode and triggers a rebuild
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      setState(() => _themeMode = mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal AI - Calorie Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const WidgetTree(),
    );
  }
}
