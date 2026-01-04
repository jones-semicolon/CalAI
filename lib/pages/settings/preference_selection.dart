import 'package:flutter/material.dart';
import '../../theme/theme_service.dart';
import '../../main.dart'; // To call MyApp.of(context) for theme changes

class PreferencesSection extends StatefulWidget {
  const PreferencesSection({super.key});

  @override
  State<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends State<PreferencesSection> {
  // -------------------------- INITIAL STATE --------------------------
  String appearance = "Light"; // CHANGED: this will load from local storage
  bool addBurnedCalories = false;
  bool rolloverCalories = false;
  bool badgeCelebration = false;

  final ThemeService _themeService =
      ThemeService(); // CHANGED: ThemeService instance

  // -------------------------- INIT STATE --------------------------
  @override
  void initState() {
    super.initState();
    _loadTheme(); // CHANGED: Load saved theme from local storage
  }

  // -------------------------- LOAD THEME --------------------------
  Future<void> _loadTheme() async {
    final savedTheme = await _themeService.loadTheme();
    setState(() {
      appearance = savedTheme;
    });
  }

  // -------------------------- SAVE THEME --------------------------
  Future<void> _saveTheme(String theme) async {
    await _themeService.saveTheme(theme);
    setState(() => appearance = theme);

    ThemeMode mode;
    if (theme == "Light") {
      mode = ThemeMode.light;
    } else if (theme == "Dark") {
      mode = ThemeMode.dark;
    } else {
      mode = ThemeMode.system;
    }

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
          // TITLE
          Padding(
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
          ),

          _divider(),

          // -------------------------- 1 — Appearance --------------------------
          Padding(
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
                      SizedBox(height: 4),
                      Text(
                        "Choose light, dark, or system appearance",
                        style: TextStyle(fontSize: 10, color: textColor),
                      ),
                    ],
                  ),
                ),

                // DROPDOWN BUTTON
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Theme.of(
                        context,
                      ).dialogTheme.surfaceTintColor,
                      borderRadius: BorderRadius.circular(14),
                      elevation: 4,

                      value: appearance, // CHANGED: dynamic value
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _saveTheme(value); // CHANGED: save to storage
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          _divider(),

          // -------------------------- 2 — Add Burned Calories --------------------------
          GestureDetector(
            onTap: () {
              setState(() => addBurnedCalories = !addBurnedCalories);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Burned Calories",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Add burned calories to daily goal",
                          style: TextStyle(fontSize: 10, color: textColor),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: addBurnedCalories,
                    onChanged: (v) {
                      setState(() => addBurnedCalories = v);
                    },
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white;
                    }),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Theme.of(context).dialogTheme.barrierColor;
                      }
                      return Theme.of(context).dialogTheme.backgroundColor;
                    }),
                    trackOutlineColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _divider(),

          // -------------------------- 3 — Rollover Calories --------------------------
          GestureDetector(
            onTap: () {
              setState(() => rolloverCalories = !rolloverCalories);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rollover Calories",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Add up to 200 leftover calories into today's goal",
                          style: TextStyle(fontSize: 10, color: textColor),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: rolloverCalories,
                    onChanged: (v) {
                      setState(() => rolloverCalories = v);
                    },
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white;
                    }),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Theme.of(context).dialogTheme.barrierColor;
                      }
                      return Theme.of(context).dialogTheme.backgroundColor;
                    }),
                    trackOutlineColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }

  Widget _divider() => Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    height: 1,
    color: Theme.of(context).splashColor,
  );
}
