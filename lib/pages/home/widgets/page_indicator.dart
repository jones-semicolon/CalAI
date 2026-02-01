
// ------------------------------------------------------------
// PAGE INDICATOR
// ------------------------------------------------------------

import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;

  const PageIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}