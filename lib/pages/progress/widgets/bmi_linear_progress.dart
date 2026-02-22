import 'package:flutter/material.dart';

/// A custom linear progress bar for displaying a BMI score.
///
/// It uses a [LinearGradient] for the track and a positioned [Container]
/// to act as a custom indicator needle.
class BmiLinearProgress extends StatelessWidget {
  final double value;
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
        final clamped = value.clamp(0.0, 1.0);
        final indicatorX = constraints.maxWidth * clamped;

        return Stack(
          clipBehavior: Clip.none,
          children: [
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
            Positioned(
              left: indicatorX - 2,
              top: (barHeight - indicatorHeight) / 2,
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
