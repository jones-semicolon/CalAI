import 'package:flutter/material.dart';

/// A small, colored pill-shaped widget that displays a motivational message
/// based on the user's progress percentage.
class ProgressMessagePill extends StatelessWidget {
  final double progressPercent;

  const ProgressMessagePill({super.key, required this.progressPercent});

  String _getMessage() {
    final percent = progressPercent.round();
    if (percent <= 24) {
      return "Getting started is the hardest part, You're ready for this!";
    } else if (percent <= 49) {
      return "You're making progress—now's the time to keep pushing!";
    } else if (percent <= 74) {
      return "You're dedication is paying off! Keep going.";
    } else if (percent <= 99) {
      return "It's the final stretch! Push yourself!";
    } else {
      return "You did it! Congratulations!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = _getMessage();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(26, 35, 138, 29),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color.fromARGB(255, 35, 138, 29),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
