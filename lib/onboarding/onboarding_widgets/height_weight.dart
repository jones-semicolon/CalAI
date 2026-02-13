import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/user_data.dart';

class HeightWeightPickerWidget extends ConsumerStatefulWidget {
  const HeightWeightPickerWidget({super.key});

  @override
  ConsumerState<HeightWeightPickerWidget> createState() =>
      _HeightWeightPickerWidgetState();
}

class _HeightWeightPickerWidgetState
    extends ConsumerState<HeightWeightPickerWidget> {
  // Local UI state for unit toggle only
  bool isMetric = false;

  // Ranges
  final feetRange = List.generate(8, (i) => i + 1);
  final inchesRange = List.generate(12, (i) => i);
  final weightLbRange = List.generate(761, (i) => i + 40);
  final cmRange = List.generate(183, (i) => i + 60);
  final weightKgRange = List.generate(481, (i) => i + 20);

  // Controllers
  late FixedExtentScrollController _ftController,
      _inController,
      _lbController,
      _cmController,
      _kgController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    // Calculate initial positions from current provider state
    int totalInches = (user.height / 2.54).round();
    int initialFt = totalInches ~/ 12;
    int initialIn = totalInches % 12;
    int initialLb = (user.weight / 0.453592).round();

    _ftController = FixedExtentScrollController(
      initialItem: feetRange.indexOf(initialFt).clamp(0, 7),
    );
    _inController = FixedExtentScrollController(
      initialItem: inchesRange.indexOf(initialIn).clamp(0, 11),
    );
    _lbController = FixedExtentScrollController(
      initialItem: weightLbRange.indexOf(initialLb).clamp(0, 760),
    );
    _cmController = FixedExtentScrollController(
      initialItem: cmRange.indexOf(user.height.round()).clamp(0, 182),
    );
    _kgController = FixedExtentScrollController(
      initialItem: weightKgRange.indexOf(user.weight.round()).clamp(0, 480),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _ftController.dispose();
    _inController.dispose();
    _lbController.dispose();
    _cmController.dispose();
    _kgController.dispose();
    super.dispose();
  }

  /// Syncs physical wheel positions to current Riverpod state
  void _syncWheels() {
    if (!mounted) return;
    final user = ref.read(userProvider);

    if (isMetric) {
      if (_cmController.hasClients) {
        _cmController.jumpToItem(
          cmRange.indexOf(user.height.round()).clamp(0, 182),
        );
      }
      if (_kgController.hasClients) {
        _kgController.jumpToItem(
          weightKgRange.indexOf(user.weight.round()).clamp(0, 480),
        );
      }
    } else {
      int totalIn = (user.height / 2.54).round();
      if (_ftController.hasClients) {
        _ftController.jumpToItem(feetRange.indexOf(totalIn ~/ 12).clamp(0, 7));
      }
      if (_inController.hasClients) {
        _inController.jumpToItem(
          inchesRange.indexOf(totalIn % 12).clamp(0, 11),
        );
      }
      if (_lbController.hasClients) {
        _lbController.jumpToItem(
          weightLbRange.indexOf((user.weight / 0.453592).round()).clamp(0, 760),
        );
      }
    }
  }

  void _updateImpHeight(int ft, int inch) {
    double cm = ((ft * 12) + inch) * 2.54;
    ref.read(userProvider.notifier).setHeight(cm);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final theme = Theme.of(context);

    // Constants for layout
    const double itemH = 40.0;
    const double pickerH = itemH * 7;

    // Derived values for Imperial display from single source of truth (CM/KG)
    int totalInches = (user.height / 2.54).round();
    int currentFt = totalInches ~/ 12;
    int currentIn = totalInches % 12;
    int currentLb = (user.weight / 0.453592).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Toggle Switch
        _buildToggleRow(theme),
        const SizedBox(height: 30),

        // 2. Headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_header("Height", theme), _header("Weight", theme)],
        ),
        const SizedBox(height: 16),

        // 3. The Pickers
        if (isMetric)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _individualWheel(
                cmRange,
                user.height.round(),
                (v) => ref.read(userProvider.notifier).setHeight(v.toDouble()),
                "cm",
                _cmController,
                itemH,
                pickerH,
              ),
              const SizedBox(width: 30),
              _individualWheel(
                weightKgRange,
                user.weight.round(),
                (v) => ref.read(userProvider.notifier).setWeight(v.toDouble()),
                "kg",
                _kgController,
                itemH,
                pickerH,
              ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _individualWheel(
                feetRange,
                currentFt,
                (v) => _updateImpHeight(v, currentIn),
                "ft",
                _ftController,
                itemH,
                pickerH,
              ),
              const SizedBox(width: 8),
              _individualWheel(
                inchesRange,
                currentIn,
                (v) => _updateImpHeight(currentFt, v),
                "in",
                _inController,
                itemH,
                pickerH,
              ),
              const SizedBox(width: 20),
              _individualWheel(
                weightLbRange,
                currentLb,
                (v) => ref.read(userProvider.notifier).setWeight(v * 0.453592),
                "lb",
                _lbController,
                itemH,
                pickerH,
              ),
            ],
          ),
      ],
    );
  }

  Widget _individualWheel(
    List<int> items,
    int selected,
    ValueChanged<int> onSet,
    String unit,
    FixedExtentScrollController ctrl,
    double itemH,
    double pickerH,
  ) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 85,
      height: pickerH,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Individual centered selector background
          Container(
            height: itemH,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryFixed,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: ctrl,
            itemExtent: itemH,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.007,
            onSelectedItemChanged: (i) {
              onSet(items[i]);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, i) {
                final isSel = items[i] == selected;
                return Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSel ? 1.0 : 1.0,
                    child: Text(
                      "${items[i]} $unit",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSel
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.outline,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.tr("Imperial"),
          style: TextStyle(
            color: !isMetric ? theme.colorScheme.onPrimary : theme.shadowColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(width: 20),
        Switch(
          value: isMetric,
          activeTrackColor: theme.colorScheme.onPrimary,
          inactiveThumbColor: theme.colorScheme.onPrimary, 
          activeThumbColor: theme.scaffoldBackgroundColor,
          inactiveTrackColor: theme.colorScheme.secondaryFixed, 
          onChanged: (v) {
            setState(() => isMetric = v);
            // Wait for frame to build new wheels before jumping controllers
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _syncWheels();
            });
          },
        ),
        const SizedBox(width: 20),
        Text(
          context.tr("Metric"),
          style: TextStyle(
            color: isMetric ? theme.colorScheme.onPrimary : theme.shadowColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _header(String t, ThemeData theme) => Text(
    context.tr(t),
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onPrimary,
    ),
  );
}
