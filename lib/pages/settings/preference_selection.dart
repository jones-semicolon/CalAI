import 'package:calai/pages/settings/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../../services/calai_firestore_service.dart';
import '../../theme/theme_service.dart';
import '../../main.dart'; // To call MyApp.of(context) for theme changes
import 'widgets/settings_divider.dart';

/// A widget that displays a section of user-configurable preferences.
///
/// This widget is stateful to manage the local state of the settings before
/// they are saved.
// Change to ConsumerStatefulWidget
class PreferencesSection extends ConsumerStatefulWidget {
  const PreferencesSection({super.key});

  @override
  ConsumerState<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends ConsumerState<PreferencesSection> {
  // --- State --- //

  String _appearance = "Light";
  // bool _badgeCelebration = false;

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

  void _updateSettings({bool? isAddCalorieBurn, bool? isRollover}) async {
    final userNotifier = ref.read(userProvider.notifier);

    // 1. Update local state via your notifier's helper
    // (Using the _update method we created in the previous turn)
    // userNotifier.update((state) => state.copyWith(
    //   settings: state.settings.copyWith(
    //     isAddCalorieBurn: isAddCalorieBurn ?? state.settings.isAddCalorieBurn,
    //     isRollover: isRollover ?? state.settings.isRollover,
    //   ),
    // ));

    userNotifier.setAddCaloriesBurned(isAddCalorieBurn ?? false);
    userNotifier.setRolloverCalories(isRollover ?? false);

    // 2. Sync to Firestore
    // We read the latest state after the update above
    final updatedSettings = ref.read(userProvider).settings;

    try {
      await ref.read(calaiServiceProvider).updateUserSettings(updatedSettings);
    } catch (e) {
      debugPrint("Failed to sync settings: $e");
      // Optional: Revert local state if sync fails
    }
  }

  // --- Build --- //

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(userProvider.select((u) => u.settings));

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
              child: ButtonTheme(
                alignedDropdown: true, // ✅ Fixes the width/alignment offset
                child: DropdownButton<String>(
                  alignment: Alignment.centerRight, // ✅ Aligns the selected text to the right
                  isDense: true, // ✅ Removes extra vertical padding
                  dropdownColor: Theme.of(context).dialogTheme.surfaceTintColor,
                  borderRadius: BorderRadius.circular(14),
                  icon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.secondary
                  ),
                  value: _appearance,
                  items: ["Light", "Dark", "Automatic"].map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Container(
                        alignment: Alignment.center, // ✅ Aligns popup items to right
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: _saveTheme,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            label: "Add Burned Calories",
            description: "Add burned calories to daily goal",
            widget: Switch(
              value: settings.isAddCalorieBurn ?? false,
              onChanged: (v) => _updateSettings(isAddCalorieBurn: v),
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
              value: settings.isRollover ?? false,
              onChanged: (v) => _updateSettings(isRollover: v),
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
        ],
      ),
    );
  }
}
