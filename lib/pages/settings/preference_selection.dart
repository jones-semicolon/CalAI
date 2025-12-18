import 'package:flutter/material.dart';
import '../../theme/theme_service.dart';
import '../../main.dart'; // To call MyApp.of(context) for theme changes

/// Preferences Section: Handles appearance, calorie settings, and badge celebration.
class PreferencesSection extends StatefulWidget {
  const PreferencesSection({super.key});

  @override
  State<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends State<PreferencesSection> {
  // -------------------------- STATE --------------------------
  String appearance = "Light";
  bool addBurnedCalories = false;
  bool rolloverCalories = false;
  bool badgeCelebration = false;

  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // -------------------------- LOAD & SAVE THEME --------------------------
  Future<void> _loadTheme() async {
    final savedTheme = await _themeService.loadTheme();
    setState(() => appearance = savedTheme);
  }

  Future<void> _saveTheme(String theme) async {
    await _themeService.saveTheme(theme);
    setState(() => appearance = theme);

    ThemeMode mode = switch (theme) {
      "Light" => ThemeMode.light,
      "Dark" => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    MyApp.of(context)?.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildTitle(context, textColor),
          _divider(),
          _buildAppearanceDropdown(context, textColor),
          _divider(),
          _buildSwitchOption(
            title: "Add Burned Calories",
            subtitle: "Add burned calories to daily goal",
            value: addBurnedCalories,
            onChanged: (v) => setState(() => addBurnedCalories = v),
          ),
          _divider(),
          _buildSwitchOption(
            title: "Rollover Calories",
            subtitle: "Add up to 200 leftover calories into today's goal",
            value: rolloverCalories,
            onChanged: (v) => setState(() => rolloverCalories = v),
          ),
          _divider(),
          _buildSwitchOption(
            title: "Badge Celebration",
            subtitle: "Show celebrations when you unlock new badges",
            value: badgeCelebration,
            onChanged: (v) => setState(() => badgeCelebration = v),
          ),
        ],
      ),
    );
  }

  /// -------------------------- TITLE --------------------------
  Widget _buildTitle(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.settings_outlined, color: textColor, size: 26),
          const SizedBox(width: 12),
          Text(
            "Preferences",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------- APPEARANCE DROPDOWN --------------------------
  Widget _buildAppearanceDropdown(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Appearance",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Choose light, dark, or system appearance",
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              ],
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Theme.of(context).dialogTheme.surfaceTintColor,
              borderRadius: BorderRadius.circular(14),
              elevation: 4,
              value: appearance,
              items: ["Light", "Dark", "Automatic"]
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Center(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) _saveTheme(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------- SWITCH OPTION --------------------------
  Widget _buildSwitchOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
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
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              thumbColor: MaterialStateProperty.all(Colors.white),
              trackColor: MaterialStateProperty.resolveWith((states) {
                return states.contains(MaterialState.selected)
                    ? Theme.of(context).dialogTheme.barrierColor
                    : Theme.of(context).dialogTheme.backgroundColor;
              }),
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------- DIVIDER --------------------------
  Widget _divider() => Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    height: 1,
    color: Theme.of(context).splashColor,
  );
}