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

  final ThemeService _themeService = ThemeService(); // CHANGED: ThemeService instance

  // -------------------------- INIT STATE --------------------------
  @override
  void initState() {
    super.initState();
    _loadTheme(); // CHANGED: Load saved theme from local storage
  }

  // -------------------------- LOAD THEME --------------------------
  Future<void> _loadTheme() async {
    final savedTheme = await _themeService.loadTheme(); // CHANGED
    setState(() {
      appearance = savedTheme; // CHANGED
    });
  }

  // -------------------------- SAVE THEME --------------------------
  Future<void> _saveTheme(String theme) async {
    await _themeService.saveTheme(theme); // CHANGED
    setState(() => appearance = theme);   // CHANGED

    // CHANGED: Update app theme dynamically
    ThemeMode mode;
    if (theme == "Light") {
      mode = ThemeMode.light;
    } else if (theme == "Dark") {
      mode = ThemeMode.dark;
    } else {
      mode = ThemeMode.system;
    }

    MyApp.of(context)?.setThemeMode(mode); // CHANGED: call MyApp to rebuild theme
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: Colors.grey.shade700,
                  size: 26,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Preferences",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          _divider(),

          // -------------------------- 1 — Appearance --------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Appearance",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Choose light, dark, or system appearance",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 117, 117, 117)
                        ),
                      ),
                    ],
                  ),
                ),

                // DROPDOWN BUTTON
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: appearance, // CHANGED: dynamic value
                      items: ["Light", "Dark", "Automatic"]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Center(
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) _saveTheme(value); // CHANGED: save to storage
                      },
                      dropdownColor: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Add Burned Calories",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Add burned calories to daily goal",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: addBurnedCalories,
                    onChanged: (v) {
                      setState(() => addBurnedCalories = v);
                    },
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rollover Calories",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Add up to 200 leftover calories into today's goal",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: rolloverCalories,
                    onChanged: (v) {
                      setState(() => rolloverCalories = v);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 1,
        color: Colors.black26,
      );
}
