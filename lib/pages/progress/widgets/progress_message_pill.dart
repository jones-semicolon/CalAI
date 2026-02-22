import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ProgressMessagePill extends StatelessWidget {
  final double progressPercent;

  const ProgressMessagePill({super.key, required this.progressPercent});

  String _getMessage() {
    final percent = progressPercent.round();
    if (percent <= 24) return "Getting started is the hardest part, You're ready for this!";
    if (percent <= 49) return "You're making progress—now's the time to keep pushing!";
    if (percent <= 74) return "You're dedication is paying off! Keep going.";
    if (percent <= 99) return "It's the final stretch! Push yourself!";
    return "You did it! Congratulations!";
  }

  @override
  Widget build(BuildContext context) {
    final message = _getMessage();
    const textStyle = TextStyle(
      color: Color.fromARGB(255, 35, 138, 29),
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );

    return Container(
      height: 32, // Fixed height is usually safer for Marquee
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(26, 35, 138, 29),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // We use a TextPainter to calculate if the text is wider than the container
          final textPainter = TextPainter(
            text: TextSpan(text: message, style: textStyle),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout(minWidth: 0, maxWidth: double.infinity);

          final isOverflowing = textPainter.size.width > constraints.maxWidth;

          return isOverflowing
              ? Marquee(
            text: message,
            style: textStyle,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 20.0, // Space before the text repeats
            velocity: 30.0,   // Pixels per second
            pauseAfterRound: const Duration(seconds: 1),
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
          )
              : Center(
            child: Text(
              message,
              style: textStyle,
              maxLines: 1,
            ),
          );
        },
      ),
    );
  }
}