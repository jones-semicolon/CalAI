import 'package:flutter/material.dart';
import 'package:calai/l10n/l10n.dart';

class UnitSelector extends StatelessWidget {
  final bool isMetric;
  final ValueChanged<bool> onChanged;

  const UnitSelector({super.key, required this.isMetric, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeStyle = TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16);
    final inactiveStyle = TextStyle(color: theme.disabledColor, fontWeight: FontWeight.bold, fontSize: 16);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.l10n.imperialLabel, style: !isMetric ? activeStyle : inactiveStyle),
        const SizedBox(width: 12),
        Switch(
          value: isMetric,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(context.l10n.metricLabel, style: isMetric ? activeStyle : inactiveStyle),
      ],
    );
  }
}
