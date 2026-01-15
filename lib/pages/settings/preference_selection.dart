import 'package:calai/pages/settings/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import '../../theme/theme_service.dart';
import '../../main.dart'; // To call MyApp.of(context) for theme changes
import 'widgets/settings_divider.dart';

/// A widget that displays a section of user-configurable preferences.
///
/// This widget is stateful to manage the local state of the settings before
/// they are saved.
class PreferencesSection extends StatefulWidget {
  const PreferencesSection({super.key});

  @override
  State<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends State<PreferencesSection> {
  // --- State --- //

  String _appearance = "Light";
  bool _addBurnedCalories = false;
  bool _rolloverCalories = false;
  bool _badgeCelebration = false;

  final ThemeService _themeService = ThemeService();

  // --- Lifecycle --- //

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // --- Logic --- //

  /// Loads the saved theme from the theme service and updates the UI.
  Future<void> _loadTheme() async {
    final savedTheme = await _themeService.loadTheme();
    setState(() => _appearance = savedTheme);
  }

  /// Saves the selected theme and applies it to the app.
  Future<void> _saveTheme(String? theme) async {
    if (theme == null) return;

    await _themeService.saveTheme(theme);
    setState(() => _appearance = theme);

    final mode = switch (theme) {
      "Light" => ThemeMode.light,
      "Dark" => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    // Use the static `of` method to find the `_MyAppState` and call the method.
    MyApp.of(context)?.setThemeMode(mode);
  }

  // --- Build --- //

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 185, 168, 209),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      // The main layout is a Column, now composed of smaller, focused widgets.
      child: Column(
        children: [
          const SettingsItemTile(label: "Preferences", icon: Icons.settings_outlined, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),),
          const SettingsDivider(),
          SettingsItemTile(
            label: "Appearance",
            description: "Choose light, dark, or system appearance",
            widget: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Theme.of(context).dialogTheme.surfaceTintColor,
                borderRadius: BorderRadius.circular(14),
                elevation: 4,
                value: _appearance,
                items: ["Light", "Dark", "Automatic"]
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Center(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _saveTheme,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            label: "Add Burned Calories",
            description: "Add burned calories to daily goal",
            widget: Switch(
              value: _addBurnedCalories,
              onChanged: (v) => setState(() => _addBurnedCalories = v),
              thumbColor: MaterialStateProperty.all(Colors.white),
              trackColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.selected)
                    ? Theme.of(context).dialogTheme.barrierColor ??
                          Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary;
              }),
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            label: "Rollover Calories",
            description: "Add up to 200 leftover calories into today's goal",
            widget: Switch(
              value: _rolloverCalories,
              onChanged: (v) => setState(() => _rolloverCalories = v),
              thumbColor: MaterialStateProperty.all(Colors.white),
              trackColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.selected)
                    ? Theme.of(context).dialogTheme.barrierColor ??
                          Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary;
              }),
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          ),
          // const SettingsDivider(),
          // SettingsItemTile(
          //   label: "Badge Celebration",
          //   description: "Show celebrations when you unlock new badges",
          //   widget: Switch(
          //     value: _badgeCelebration,
          //     onChanged: (v) => setState(() => _badgeCelebration = v),
          //     thumbColor: MaterialStateProperty.all(Colors.white),
          //     trackColor: MaterialStateProperty.resolveWith((states) {
          //       return states.contains(MaterialState.selected)
          //           ? Theme.of(context).dialogTheme.barrierColor ??
          //                 Theme.of(context).primaryColor
          //           : Theme.of(context).colorScheme.secondary;
          //     }),
          //     trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          //   ),
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          // ),
        ],
      ),
    );
  }
}
