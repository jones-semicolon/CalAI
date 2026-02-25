import 'dart:async';

import 'package:calai/features/home_widget/providers/home_widget_permission_provider.dart';
import 'package:calai/features/home_widget/services/home_widget_permission_settings_service.dart';
import 'package:calai/features/home_widget/services/home_widget_service.dart';
import 'package:calai/pages/settings/screens/edit_goals.dart';
import 'package:calai/pages/settings/settings_item.dart';
import 'package:calai/pages/settings/widgets/settings_divider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/language_card.dart';
import '../screens/personal_details.dart';
import '../weight_history/weight_history_page.dart';

const String _selectedHomeWidgetPrefKey = 'selected_home_widget_kind';
const String _selectedHomeWidgetsPrefKey = 'selected_home_widget_kinds';
const String _pendingHomeWidgetsPrefKey = 'pending_home_widget_kinds';

class SettingsGroup extends ConsumerStatefulWidget {
  const SettingsGroup({super.key});

  @override
  ConsumerState<SettingsGroup> createState() => _SettingsGroupState();
}

class _SettingsGroupState extends ConsumerState<SettingsGroup>
    with WidgetsBindingObserver {
  Set<HomeWidgetKind> _selectedWidgetKinds = {HomeWidgetKind.calories};
  Set<HomeWidgetKind> _pendingWidgetKinds = <HomeWidgetKind>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSelectedHomeWidgetKind();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_syncSelectionFromHomeAndPermissions());
    }
  }

  Future<void> _loadSelectedHomeWidgetKind() async {
    _pendingWidgetKinds = await _loadPendingHomeWidgets();
    final initialKinds = await _syncSelectionFromHomeAndPermissions();
    if (!mounted) return;
    setState(() {
      _selectedWidgetKinds = initialKinds;
    });
    await _saveSelectedHomeWidgets(initialKinds);
  }

  Future<Set<HomeWidgetKind>> _loadPendingHomeWidgets() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_pendingHomeWidgetsPrefKey) ?? const [];
    return _widgetKindsFromValues(raw);
  }

  Future<void> _saveSelectedHomeWidgets(Set<HomeWidgetKind> kinds) async {
    final prefs = await SharedPreferences.getInstance();
    final values = kinds.map(_widgetKindToValue).toList(growable: false);
    await prefs.setStringList(_selectedHomeWidgetsPrefKey, values);

    // Keep old key for backward compatibility with previous app versions.
    final fallbackValue = values.isNotEmpty ? values.first : '1';
    await prefs.setString(_selectedHomeWidgetPrefKey, fallbackValue);
  }

  Future<void> _savePendingHomeWidgets(Set<HomeWidgetKind> kinds) async {
    final prefs = await SharedPreferences.getInstance();
    final values = kinds.map(_widgetKindToValue).toList(growable: false);
    await prefs.setStringList(_pendingHomeWidgetsPrefKey, values);
  }

  Future<Set<HomeWidgetKind>> _syncSelectionFromHomeAndPermissions() async {
    final pinnedKinds = await HomeWidgetService.getPinnedWidgetKinds();
    if (!mounted) return pinnedKinds;

    final pendingKinds = _isIOS
        ? _pendingWidgetKinds.difference(pinnedKinds)
        : <HomeWidgetKind>{};
    final effectiveKinds = {...pinnedKinds, ...pendingKinds};

    setState(() {
      _pendingWidgetKinds = pendingKinds;
      _selectedWidgetKinds = effectiveKinds;
    });
    await _saveSelectedHomeWidgets(effectiveKinds);
    await _savePendingHomeWidgets(pendingKinds);

    for (final kind in HomeWidgetKind.values) {
      ref.read(homeWidgetPermissionProvider(kind).notifier).state = pinnedKinds
          .contains(kind);
    }

    return effectiveKinds;
  }

  Future<void> _openHomeWidgetPicker() async {
    final tempSelected = <HomeWidgetKind>{..._selectedWidgetKinds};
    bool isRequesting = false;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> onToggle(HomeWidgetKind selected) async {
              final wasSelected = tempSelected.contains(selected);
              final isPending = _pendingWidgetKinds.contains(selected);

              setSheetState(() {
                if (wasSelected) {
                  // Android launchers own widget removal.
                  // iOS also owns widget removal once pinned.
                } else {
                  tempSelected.add(selected);
                }
                isRequesting = true;
              });

              if (wasSelected) {
                if (_isIOS && isPending) {
                  tempSelected.remove(selected);
                  _pendingWidgetKinds.remove(selected);
                  if (mounted) {
                    setState(() {
                      _selectedWidgetKinds = {...tempSelected};
                    });
                  }
                  await _savePendingHomeWidgets(_pendingWidgetKinds);
                  await _saveSelectedHomeWidgets(tempSelected);

                  if (!mounted) return;
                  setSheetState(() => isRequesting = false);
                  final messenger = ScaffoldMessenger.of(this.context);
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        '${_widgetDisplayName(selected)} removed from selection.',
                      ),
                    ),
                  );
                  return;
                }

                final synced = await _syncSelectionFromHomeAndPermissions();
                if (!mounted) return;
                tempSelected
                  ..clear()
                  ..addAll(synced);
                setSheetState(() => isRequesting = false);
                final messenger = ScaffoldMessenger.of(this.context);
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'To remove ${_widgetDisplayName(selected)}, remove it from your home screen. Selection syncs automatically.',
                    ),
                  ),
                );
                return;
              }

              if (_isIOS) {
                tempSelected.add(selected);
                _pendingWidgetKinds.add(selected);
                if (mounted) {
                  setState(() {
                    _selectedWidgetKinds = {...tempSelected};
                  });
                }
                await _savePendingHomeWidgets(_pendingWidgetKinds);
                await _saveSelectedHomeWidgets(tempSelected);

                if (!mounted) return;
                setSheetState(() => isRequesting = false);
                final messenger = ScaffoldMessenger.of(this.context);
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'To add ${_widgetDisplayName(selected)}, long-press the Home Screen, tap +, then select Cal AI.',
                    ),
                  ),
                );
                return;
              }

              final hasPermission = await requestHomeWidgetPermission(
                ref,
                selected,
              );

              if (!mounted) return;
              final synced = await _syncSelectionFromHomeAndPermissions();
              if (!mounted) return;
              tempSelected
                ..clear()
                ..addAll(synced);
              setSheetState(() => isRequesting = false);

              late final String message;
              if (hasPermission) {
                message = '${_widgetDisplayName(selected)} widget added.';
              } else {
                final openedSettings =
                    await HomeWidgetPermissionSettingsService.openSpecialPermissions();
                if (!mounted) return;
                message = openedSettings
                    ? 'Permission needed to add ${_widgetDisplayName(selected)}. We opened settings for you.'
                    : 'Could not open permission settings. Please enable permissions manually to add ${_widgetDisplayName(selected)}.';
              }

              final messenger = ScaffoldMessenger.of(this.context);
              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(SnackBar(content: Text(message)));
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Choose Home Widgets',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isRequesting
                            ? (_isIOS
                                  ? 'Updating widget selection...'
                                  : 'Requesting widget permission...')
                            : 'Tap options to add or remove widgets.',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _WidgetOptionTile(
                        title: 'Widget 1',
                        subtitle: 'Calorie tracker widget',
                        isSelected: tempSelected.contains(
                          HomeWidgetKind.calories,
                        ),
                        onTap: () => onToggle(HomeWidgetKind.calories),
                      ),
                      _WidgetOptionTile(
                        title: 'Widget 2',
                        subtitle: 'Nutrition tracker widget',
                        isSelected: tempSelected.contains(
                          HomeWidgetKind.nutrition,
                        ),
                        onTap: () => onToggle(HomeWidgetKind.nutrition),
                      ),
                      _WidgetOptionTile(
                        title: 'Widget 3',
                        subtitle: 'Streak tracker widget',
                        isSelected: tempSelected.contains(
                          HomeWidgetKind.streak,
                        ),
                        onTap: () => onToggle(HomeWidgetKind.streak),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static String _widgetKindToValue(HomeWidgetKind kind) {
    switch (kind) {
      case HomeWidgetKind.calories:
        return '1';
      case HomeWidgetKind.nutrition:
        return '2';
      case HomeWidgetKind.streak:
        return '3';
    }
  }

  static HomeWidgetKind _widgetKindFromValue(String value) {
    switch (value) {
      case '2':
      case 'nutrition':
        return HomeWidgetKind.nutrition;
      case '3':
      case 'streak':
        return HomeWidgetKind.streak;
      case '1':
      case 'calories':
      default:
        return HomeWidgetKind.calories;
    }
  }

  static Set<HomeWidgetKind> _widgetKindsFromValues(List<String> values) {
    return values.map(_widgetKindFromValue).toSet();
  }

  static String _widgetLabel(HomeWidgetKind kind) {
    switch (kind) {
      case HomeWidgetKind.calories:
        return 'Widget 1';
      case HomeWidgetKind.nutrition:
        return 'Widget 2';
      case HomeWidgetKind.streak:
        return 'Widget 3';
    }
  }

  static String _widgetDisplayName(HomeWidgetKind kind) {
    switch (kind) {
      case HomeWidgetKind.calories:
        return 'Calorie Tracker';
      case HomeWidgetKind.nutrition:
        return 'Nutrition Tracker';
      case HomeWidgetKind.streak:
        return 'Streak Tracker';
    }
  }

  bool get _isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  String _selectedWidgetsSummary() {
    if (_selectedWidgetKinds.isEmpty) return 'No widgets on home screen';

    final labels = HomeWidgetKind.values
        .where(_selectedWidgetKinds.contains)
        .map(_widgetLabel)
        .join(', ');
    return 'Selected: $labels';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 185, 168, 209),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Column(
        children: [
          SettingsItemTile(
            icon: Icons.person_outline,
            label: "Personal Details",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PersonalDetailsPage()),
            ),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.pie_chart_outline,
            label: "Adjust Macronutrients",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditGoalsView()),
            ),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.monitor_weight_outlined,
            label: "Weight History",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WeightHistoryView()),
            ),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.widgets_outlined,
            label: "Home Widget",
            description: _selectedWidgetsSummary(),
            onTap: _openHomeWidgetPicker,
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.language_outlined,
            label: "Language",
            onTap: () => _showLanguageDialog(context),
          ),
        ],
      ),
    );
  }
}

void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: LanguageCard(onClose: () => Navigator.pop(context)),
      );
    },
  );
}

class _WidgetOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _WidgetOptionTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final titleColor = isSelected ? colorScheme.primary : colorScheme.onSurface;
    final subtitleColor = isSelected
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurfaceVariant;
    final tileColor = isSelected
        ? colorScheme.secondaryContainer.withValues(alpha: 0.6)
        : Colors.transparent;
    final borderColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.18)
        : theme.dividerColor.withValues(alpha: 0.2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 12,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                isSelected
                    ? Icon(Icons.check_circle, color: colorScheme.primary)
                    : Icon(Icons.circle_outlined, color: colorScheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
