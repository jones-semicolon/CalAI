import 'package:flutter/material.dart';
import '../../../data/health_data.dart';

class UnitToggle extends StatelessWidget {
  final WeightUnit unit;
  final ValueChanged<WeightUnit> onChanged;

  const UnitToggle({super.key, required this.unit, required this.onChanged});

  static const double _scale = 0.8;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 140 * _scale,
      height: 44 * _scale,
      padding: EdgeInsets.all(4 * _scale),
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        borderRadius: BorderRadius.circular(16 * _scale),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: unit == WeightUnit.kg
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: 64 * _scale,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryFixed,
                borderRadius: BorderRadius.circular(12 * _scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8 * _scale,
                    offset: Offset(0, 4 * _scale),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _label(
                'kg',
                unit == WeightUnit.kg,
                () => onChanged(WeightUnit.kg),
                context,
              ),
              _label(
                'lbs',
                unit == WeightUnit.lbs,
                () => onChanged(WeightUnit.lbs),
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(
    String text,
    bool selected,
    VoidCallback onTap,
    BuildContext context,
  ) {
    ThemeData theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected
                  ? theme.colorScheme.onTertiary
                  : theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
