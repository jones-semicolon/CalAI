import 'package:flutter/material.dart';

/// A widget that animates a sliding and fading transition when its numeric [value] changes.
///
/// This widget uses an [AnimatedSwitcher] to create a smooth "odometer" style effect,
/// perfect for displaying values that update dynamically.
class AnimatedSlideNumber extends StatelessWidget {
  final String value;
  final String unit;
  final TextStyle style;
  final bool reverse;
  final bool inAnim;
  final bool outAnim;

  const AnimatedSlideNumber({
    super.key,
    required this.value,
    this.unit = "",
    required this.style,
    this.reverse = false,
    this.inAnim = true,
    this.outAnim = true,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap everything in AnimatedDefaultTextStyle to animate font properties
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: style,
      curve: Curves.easeInOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isIncoming = child.key == ValueKey(value);

          final inSlide = Tween<Offset>(
            begin: Offset(0, reverse ? 1 : -1), // Adjusted based on reverse
            end: Offset.zero,
          ).animate(animation);

          final outSlide = Tween<Offset>(
            begin: Offset(0, reverse ? -1 : 1), // Adjusted based on reverse
            end: Offset.zero,
          ).animate(animation);

          return ClipRect(
            child: FadeTransition(
              opacity: animation, // Use the raw animation for cleaner fading
              child: SlideTransition(
                position: isIncoming ? inSlide : outSlide,
                child: child,
              ),
            ),
          );
        },
        child: Text(
          '$value$unit',
          key: ValueKey(value),
          // We don't pass 'style' here so it inherits from AnimatedDefaultTextStyle
        ),
      ),
    );
  }
}