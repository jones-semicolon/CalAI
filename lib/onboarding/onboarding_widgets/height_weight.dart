import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';

class HeightWeightPickerWidget extends ConsumerStatefulWidget {
  const HeightWeightPickerWidget({super.key});

  @override
  ConsumerState<HeightWeightPickerWidget> createState() =>
      _HeightWeightPickerWidgetState();
}

class _HeightWeightPickerWidgetState extends ConsumerState<HeightWeightPickerWidget> {
  bool isMetric = false;

  // Ranges
  final feetRange = List.generate(8, (i) => i + 1);
  final inchesRange = List.generate(12, (i) => i);
  final weightLbRange = List.generate(761, (i) => i + 40);
  final cmRange = List.generate(183, (i) => i + 60);
  final weightKgRange = List.generate(481, (i) => i + 20);

  late FixedExtentScrollController _ftController,
      _inController,
      _lbController,
      _cmController,
      _kgController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    // Initial Unit Detection
    isMetric = user.body.weightUnit == WeightUnit.kg;

    int totalInches = (user.body.height / 2.54).round();
    int initialFt = totalInches ~/ 12;
    int initialIn = totalInches % 12;
    int initialLb = (user.body.currentWeight / 0.453592).round();

    _ftController = FixedExtentScrollController(initialItem: feetRange.indexOf(initialFt).clamp(0, 7));
    _inController = FixedExtentScrollController(initialItem: inchesRange.indexOf(initialIn).clamp(0, 11));
    _lbController = FixedExtentScrollController(initialItem: weightLbRange.indexOf(initialLb).clamp(0, 760));
    _cmController = FixedExtentScrollController(initialItem: cmRange.indexOf(user.body.height.round()).clamp(0, 182));
    _kgController = FixedExtentScrollController(initialItem: weightKgRange.indexOf(user.body.currentWeight.round()).clamp(0, 480));
  }

  @override
  void dispose() {
    _ftController.dispose();
    _inController.dispose();
    _lbController.dispose();
    _cmController.dispose();
    _kgController.dispose();
    super.dispose();
  }

  // Helper to update height from Imperial Wheels
  void _updateHeightImperial() {
    final ft = feetRange[_ftController.selectedItem];
    final inch = inchesRange[_inController.selectedItem];
    final double totalCm = ((ft * 12) + inch) * 2.54;

    ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(
      body: s.body.copyWith(
        height: totalCm,
        heightUnit: HeightUnit.ft,
      ),
    ));
  }

  void _syncWheels() {
    if (!mounted) return;
    final user = ref.read(userProvider);

    if (isMetric) {
      if (_cmController.hasClients) _cmController.jumpToItem(cmRange.indexOf(user.body.height.round()).clamp(0, 182));
      if (_kgController.hasClients) _kgController.jumpToItem(weightKgRange.indexOf(user.body.currentWeight.round()).clamp(0, 480));
    } else {
      int totalIn = (user.body.height / 2.54).round();
      if (_ftController.hasClients) _ftController.jumpToItem(feetRange.indexOf(totalIn ~/ 12).clamp(0, 7));
      if (_inController.hasClients) _inController.jumpToItem(inchesRange.indexOf(totalIn % 12).clamp(0, 11));
      if (_lbController.hasClients) _lbController.jumpToItem(weightLbRange.indexOf((user.body.currentWeight / 0.453592).round()).clamp(0, 760));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userDataProvider = ref.read(userProvider.notifier);
    final theme = Theme.of(context);

    const double itemH = 40.0;
    const double pickerH = itemH * 7;

    int totalInches = (user.body.height / 2.54).round();
    int currentFt = totalInches ~/ 12;
    int currentIn = totalInches % 12;
    int currentLb = (user.body.currentWeight / 0.453592).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToggleRow(theme),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_header("Height", theme), _header("Weight", theme)],
        ),
        const SizedBox(height: 16),

        if (isMetric)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _individualWheel(
                cmRange,
                user.body.height.round(),
                    (v) => userDataProvider.updateLocal((s) => s.copyWith(body: s.body.copyWith(height: v.toDouble(), heightUnit: HeightUnit.cm))),
                "cm",
                _cmController,
                itemH, pickerH,
              ),
              const SizedBox(width: 30),
              _individualWheel(
                weightKgRange,
                user.body.currentWeight.round(),
                    (v) => userDataProvider.updateLocal((s) => s.copyWith(body: s.body.copyWith(currentWeight: v.toDouble(), weightUnit: WeightUnit.kg))),
                "kg",
                _kgController,
                itemH, pickerH,
              ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _individualWheel(feetRange, currentFt, (_) => _updateHeightImperial(), "ft", _ftController, itemH, pickerH),
              const SizedBox(width: 8),
              _individualWheel(inchesRange, currentIn, (_) => _updateHeightImperial(), "in", _inController, itemH, pickerH),
              const SizedBox(width: 20),
              _individualWheel(
                weightLbRange,
                currentLb,
                    (v) => userDataProvider.updateLocal((s) => s.copyWith(body: s.body.copyWith(currentWeight: v * 0.453592, weightUnit: WeightUnit.lbs))),
                "lb",
                _lbController,
                itemH, pickerH,
              ),
            ],
          ),
      ],
    );
  }

  Widget _individualWheel(List<int> items, int selected, ValueChanged<int> onSet, String unit, FixedExtentScrollController ctrl, double itemH, double pickerH) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 85,
      height: pickerH,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(height: itemH, decoration: BoxDecoration(color: theme.colorScheme.secondary.withOpacity(0.25), borderRadius: BorderRadius.circular(12))),
          ListWheelScrollView.useDelegate(
            controller: ctrl,
            itemExtent: itemH,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) => onSet(items[i]),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, i) {
                final isSel = items[i] == selected;
                return Center(
                  child: Text(
                    "${items[i]} $unit",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSel ? theme.colorScheme.primary : theme.colorScheme.secondary.withOpacity(0.25),
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
          "Imperial",
          style: TextStyle(
            color: !isMetric ? theme.colorScheme.primary : theme.shadowColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(width: 20),
        Switch(
          value: isMetric,
          thumbColor: MaterialStateProperty.all(Colors.white),
          trackColor: MaterialStateProperty.resolveWith((states) {
            return states.contains(MaterialState.selected)
                ? Theme
                .of(context)
                .dialogTheme
                .barrierColor ??
                Theme
                    .of(context)
                    .primaryColor
                : Theme
                .of(context)
                .colorScheme
                .secondary;
          }),
          trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
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
          "Metric",
          style: TextStyle(
            color: isMetric ? theme.colorScheme.primary : theme.shadowColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _header(String t, ThemeData theme) => Text(t, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface));
}