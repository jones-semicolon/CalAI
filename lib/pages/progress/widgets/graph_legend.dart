import 'package:flutter/material.dart';

/// A small widget to display a colored icon and a label, for use in graph legends.
class GraphLegend extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  const GraphLegend({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
