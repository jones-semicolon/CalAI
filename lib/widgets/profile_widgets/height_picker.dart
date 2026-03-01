import 'package:flutter/material.dart';
import 'package:calai/l10n/l10n.dart';

class HeightPicker extends StatefulWidget {
  final bool isMetric;
  final double initialHeightCm;
  final ValueChanged<double> onHeightChanged;

  const HeightPicker({
    super.key,
    required this.isMetric,
    required this.initialHeightCm,
    required this.onHeightChanged,
  });

  @override
  State<HeightPicker> createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  late double currentHeightCm;
  late int localFt;
  late int localInch;

  // 1. Add Controllers
  late FixedExtentScrollController metricController;
  late FixedExtentScrollController ftController;
  late FixedExtentScrollController inController;

  @override
  void initState() {
    super.initState();
    currentHeightCm = widget.initialHeightCm;
    _updateLocalImperialValues(currentHeightCm);

    // 2. Initialize Controllers with correct indices
    // Metric index: Selected value - Start value (60)
    metricController = FixedExtentScrollController(
      initialItem: (currentHeightCm.round() - 60).clamp(0, 182),
    );

    // Imperial indices: Value - Start value
    ftController = FixedExtentScrollController(
      initialItem: (localFt - 1).clamp(0, 7),
    );
    inController = FixedExtentScrollController(
      initialItem: localInch.clamp(0, 11),
    );
  }

  @override
  void dispose() {
    // 3. Don't forget to dispose!
    metricController.dispose();
    ftController.dispose();
    inController.dispose();
    super.dispose();
  }

  void _updateLocalImperialValues(double cm) {
    int totalInches = (cm / 2.54).round();
    localFt = totalInches ~/ 12;
    localInch = totalInches % 12;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.l10n.heightLabel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 20),
        widget.isMetric
            ? _buildWheel(
          items: List.generate(183, (i) => i + 60),
          selected: currentHeightCm.round(),
          unit: "cm",
          onChanged: (val) {
            setState(() => currentHeightCm = val.toDouble());
            widget.onHeightChanged(currentHeightCm);
          },
          controller: metricController,
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWheel(
              items: List.generate(8, (i) => i + 1),
              selected: localFt,
              unit: "ft",
              onChanged: (v) {
                setState(() {
                  localFt = v;
                  currentHeightCm = ((localFt * 12) + localInch) * 2.54;
                });
                widget.onHeightChanged(currentHeightCm);
              },
              controller: ftController
            ),
            const SizedBox(width: 12),
            _buildWheel(
              items: List.generate(12, (i) => i),
              selected: localInch,
              unit: "in",
              onChanged: (v) {
                setState(() {
                  localInch = v;
                  currentHeightCm = ((localFt * 12) + localInch) * 2.54;
                });
                widget.onHeightChanged(currentHeightCm);
              },
              controller: inController
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWheel({
    required List<int> items,
    required int selected,
    required String unit,
    required ValueChanged<int> onChanged,
    required FixedExtentScrollController controller,
  }) {
    return SizedBox(
      width: 85,
      height: 150, // Controlled height
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: controller, // ✅ Pass the controller here
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) => onChanged(items[i]),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, i) {
                final isSel = items[i] == selected;
                return Center(
                  child: Text(
                    "${items[i]} $unit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      color: isSel
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.withOpacity(0.5),
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
}
