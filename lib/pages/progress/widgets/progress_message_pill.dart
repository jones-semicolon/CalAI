import 'package:flutter/cupertino.dart';

class ProgressMessagePill extends StatelessWidget {
  final double progressPercent;

  const ProgressMessagePill({super.key, required this.progressPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(26, 35, 138, 29),
      ),
      child: Text(
        _message(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color.fromARGB(255, 35, 138, 29),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  String _message() {
    final p = progressPercent.round();
    if (p <= 24) return "Getting started is the hardest part, You're ready for this!";
    if (p <= 49) return "You're making progress—now's the time to keep pushing!";
    if (p <= 74) return "Your dedication is paying off! Keep going.";
    if (p <= 99) return "It's the final stretch! Push yourself!";
    return "You did it! Congratulations!";
  }
}
