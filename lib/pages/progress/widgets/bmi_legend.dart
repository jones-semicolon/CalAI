import 'package:flutter/material.dart';

/// A small widget to display a colored circle next to a text label,
/// for use in the BMI card's legend.
class BmiLegend extends StatelessWidget {
  final Color color;
  final String label;

  const BmiLegend({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // FittedBox ensures the widget scales down gracefully if space is limited.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
