import 'package:flutter/material.dart';

/// A header widget for the progress graphs, displaying a title, a total value,
/// and a percentage change indicator.
class GraphHeader extends StatelessWidget {
  final String title;
  final double totalValue;
  final String unit;
  final double percentage;

  const GraphHeader({
    super.key,
    required this.title,
    required this.totalValue,
    required this.unit,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              totalValue.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              ' $unit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            _PercentageIndicator(percentage: percentage),
          ],
        ),
      ],
    );
  }
}

/// A private widget to display the percentage change with an up/down arrow.
class _PercentageIndicator extends StatelessWidget {
  final double percentage;

  const _PercentageIndicator({required this.percentage});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = percentage > 24;
    final Color color = isPositive
        ? const Color.fromARGB(255, 32, 141, 26)
        : const Color.fromARGB(255, 203, 77, 55);

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              isPositive ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 18,
            ),
          ),
          const WidgetSpan(
            child: SizedBox(width: 4),
          ),
          TextSpan(
            text: '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
