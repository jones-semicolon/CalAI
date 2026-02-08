import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

class SegmentedSelector<T> extends StatelessWidget {
  final List<RangeOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final double height;

  const SegmentedSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex =
    options.indexWhere((o) => o.value == selected);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / options.length;

          return SizedBox(
            height: height,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOut,
                  left: selectedIndex * itemWidth,
                  width: itemWidth,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                Row(
                  children: options.map((o) {
                    final isSelected = o.value == selected;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChanged(o.value),
                        child: Center(
                          child: Text(
                            o.label,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RangeOption<T> {
  final T value;     // the actual value you care about
  final String label; // what the user sees

  const RangeOption({
    required this.value,
    required this.label,
  });
}
