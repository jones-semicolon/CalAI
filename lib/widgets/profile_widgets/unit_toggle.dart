import 'package:flutter/material.dart';

import '../../enums/user_enums.dart';

class UnitToggle extends StatelessWidget {
  final WeightUnit unit;
  final ValueChanged<WeightUnit> onChanged;

  const UnitToggle({
    super.key,
    required this.unit,
    required this.onChanged,
  });

  static const double _scale = 0.8;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor = theme.colorScheme.onTertiary.withOpacity(0.5);
    final thumbColor = theme.colorScheme.surface;
    final selectedTextColor = theme.colorScheme.primary;
    final unselectedTextColor = theme.colorScheme.onPrimary;

    return Container(
      width: 140 * _scale,
      height: 44 * _scale,
      padding: EdgeInsets.all(4 * _scale),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16 * _scale),
      ),
      child: Stack(
        children: [
          // ✅ Moving thumb
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: unit != WeightUnit.kg
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: 64 * _scale,
              height: double.infinity, // ✅ full height inside
              decoration: BoxDecoration(
                color: thumbColor,
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

          // ✅ Labels row
          Row(
            children: [
              _label(
                text: WeightUnit.lbs.value,
                selected: unit == WeightUnit.lbs,
                selectedTextColor: selectedTextColor,
                unselectedTextColor: unselectedTextColor,
                onTap: () => onChanged(WeightUnit.lbs),
              ),
              _label(
                text: WeightUnit.kg.value,
                selected: unit == WeightUnit.kg,
                selectedTextColor: selectedTextColor,
                unselectedTextColor: unselectedTextColor,
                onTap: () => onChanged(WeightUnit.kg),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label({
    required String text,
    required bool selected,
    required Color selectedTextColor,
    required Color unselectedTextColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12 * _scale),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? selectedTextColor : unselectedTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
