import 'package:flutter/material.dart';

/// A widget that animates a sliding and fading transition when its numeric [value] changes.
///
/// This widget uses an [AnimatedSwitcher] to create a smooth "odometer" style effect,
/// perfect for displaying values that update dynamically.
class AnimatedSlideNumber extends StatelessWidget {
  /// The text value to display. Changing this value triggers the animation.
  final String value;

  /// Optional text to append to the value (e.g., "kg", "%").
  final String unit;

  /// The [TextStyle] to apply to the number.
  final TextStyle style;

  /// If `true`, the animation slides in from the bottom and out from the top.
  /// If `false` (default), it slides in from the top and out from the bottom.
  final bool reverse;

  /// If `true` (default), the incoming number will fade and slide in.
  final bool inAnim;

  /// If `true` (default), the outgoing number will fade and slide out.
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final isIncoming = child.key == ValueKey(value);

        // Define slide transitions for incoming and outgoing children.
        final inSlide = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation);

        final outSlide = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation);

        // Define fade transitions.
        final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(animation);

        return ClipRect(
          child: FadeTransition(
            // Apply fade based on whether the child is incoming or outgoing.
            opacity: isIncoming
                ? (inAnim ? fadeIn : const AlwaysStoppedAnimation(1))
                : (outAnim ? fadeOut : const AlwaysStoppedAnimation(1)),
            child: SlideTransition(
              // Apply slide based on the 'reverse' flag.
              position: reverse
                  ? (isIncoming ? outSlide : inSlide)
                  : (isIncoming ? inSlide : outSlide),
              child: child,
            ),
          ),
        );
      },
      // The Key is crucial for AnimatedSwitcher to identify which child is new.
      child: Text(
        reverse ? '$value$unit' : value,
        key: ValueKey(value),
        style: style,
      ),
    );
  }
}