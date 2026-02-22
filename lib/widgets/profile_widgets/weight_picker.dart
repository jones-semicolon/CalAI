import 'package:flutter/material.dart';

class WeightPicker extends StatefulWidget {
  final bool isMetric;
  final double initialWeightKg;
  final ValueChanged<double> onWeightChanged;

  const WeightPicker({
    super.key,
    required this.isMetric,
    required this.initialWeightKg,
    required this.onWeightChanged,
  });

  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  late double currentWeightKg;

  @override
  void initState() {
    super.initState();
    currentWeightKg = widget.initialWeightKg;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Weight", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 20),
        Center(
          child: widget.isMetric
              ? _buildWheel(
            items: List.generate(481, (i) => i + 20), // 20kg to 500kg
            selected: currentWeightKg.round(),
            unit: "kg",
            onChanged: (val) {
              setState(() => currentWeightKg = val.toDouble());
              widget.onWeightChanged(currentWeightKg);
            },
          )
              : _buildWheel(
            items: List.generate(761, (i) => i + 40), // 40lb to 800lb
            selected: (currentWeightKg / 0.453592).round(),
            unit: "lb",
            onChanged: (val) {
              setState(() => currentWeightKg = val * 0.453592);
              widget.onWeightChanged(currentWeightKg);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWheel({
    required List<int> items,
    required int selected,
    required String unit,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      width: 100, // Slightly wider for 3-digit weights
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Selection Indicator
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ListWheelScrollView.useDelegate(
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