import 'package:calai/enums/user_enums.dart';
import 'package:calai/l10n/l10n.dart';
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

  void _updateSettings({bool? isAddCalorieBurn, bool? isRollover, bool? isImperial}) async {
    final userNotifier = ref.read(userProvider.notifier);

    // 1. Update only the specific field that was changed.
    // We don't check the value of the other setting here.
    if (isAddCalorieBurn != null) {
      userNotifier.setAddCaloriesBurned(isAddCalorieBurn);
    }

    if (isRollover != null) {
      userNotifier.setRolloverCalories(isRollover);
    }

    if (isImperial != null) {
      userNotifier.setMeasurementUnit(isImperial ? MeasurementUnit.imperial : MeasurementUnit.metric);
    }

    // 2. Sync the updated settings object to Firestore
    try {
      // We read the state after the notifier has updated it
      final updatedSettings = ref.read(userProvider).settings;
      await ref.read(calaiServiceProvider).updateUserSettings(updatedSettings);

      debugPrint("✅ Settings synced: Burned: ${updatedSettings.isAddCalorieBurn}, Rollover: ${updatedSettings.isRollover}");
    } catch (e) {
      debugPrint("❌ Failed to sync settings: $e");
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
          SettingsItemTile(
            label: context.l10n.preferencesLabel,
            icon: Icons.settings_outlined,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            label: context.l10n.appearanceLabel,
            description: context.l10n.appearanceDescription,
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
                          _appearanceLabel(context, e),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            label: context.l10n.addBurnedCaloriesLabel,
            description: context.l10n.addBurnedCaloriesDescription,
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
            label: context.l10n.rolloverCaloriesLabel,
            description: context.l10n.rolloverCaloriesDescription,
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
          const SettingsDivider(),
          SettingsItemTile(
            label: context.l10n.measurementUnitLabel,
            description: context.l10n.measurementUnitDescription,
            widget: Switch(
              value: settings.measurementUnit?.isImperial ?? false,
              onChanged: (v) => _updateSettings(isImperial: v),
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

  String _appearanceLabel(BuildContext context, String raw) {
    switch (raw) {
      case "Light":
        return context.l10n.lightLabel;
      case "Dark":
        return context.l10n.darkLabel;
      default:
        return context.l10n.automaticLabel;
    }
  }
}
