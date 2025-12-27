import 'package:flutter/material.dart';

class AnimatedSlideNumber extends StatelessWidget {
  final String value;
  final TextStyle style;
  final String unit;
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Slide animations
        final inSlide = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation);

        final outSlide = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation);

        // Fade animations
        final fadeIn = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(animation);

        final fadeOut = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(animation);

        final isIncoming = child.key == ValueKey(value);

        return ClipRect(
          child: FadeTransition(
            opacity: isIncoming
                ? (inAnim ? fadeIn : const AlwaysStoppedAnimation(1))
                : (outAnim ? fadeOut : const AlwaysStoppedAnimation(1)),
            child: SlideTransition(
              position: reverse
                  ? (isIncoming ? outSlide : inSlide)
                  : (isIncoming ? inSlide : outSlide),
              child: child,
            ),
          ),
        );
      },
      child: Text(
        reverse ? '$value$unit' : value,
        key: ValueKey(value),
        style: style,
      ),
    );
  }
}
