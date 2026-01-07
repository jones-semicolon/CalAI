import 'package:flutter/material.dart';

/// A custom linear progress bar for displaying a BMI score.
///
/// It uses a [LinearGradient] for the track and a positioned [Container]
/// to act as a custom indicator needle.
class BmiLinearProgress extends StatelessWidget {
  final double value; // A value between 0.0 and 1.0.
  final Color blue;
  final Color green;
  final Color orange;
  final Color red;

  const BmiLinearProgress({
    super.key,
    required this.value,
    required this.blue,
    required this.green,
    required this.orange,
    required this.red,
  });

  @override
  Widget build(BuildContext context) {
    const barHeight = 10.0;
    const indicatorHeight = 25.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the horizontal position of the indicator needle.
        final indicatorX = constraints.maxWidth * value;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // The main gradient bar.
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [blue, green, orange, red],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
            // The indicator needle, positioned along the bar.
            Positioned(
              left: indicatorX - 2, // Center the needle on its position
              top: (barHeight - indicatorHeight) / 2, // Center vertically
              child: Container(
                width: 3,
                height: indicatorHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
