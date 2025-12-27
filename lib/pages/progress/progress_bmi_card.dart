import 'package:flutter/material.dart';
import 'progress_page.dart';

class ProgressBmiCard extends StatelessWidget {
  final double bmi;
  final int age;
  final Sex sex;

  const ProgressBmiCard({
    super.key,
    required this.bmi,
    required this.age,
    required this.sex,
  });

  // ---------------- AGE LOGIC ----------------

  bool get isAdult => age >= 18;

  // --------------------------------------------------------------------------
  // ADULT BMI INTERPRETATION
  // --------------------------------------------------------------------------
  static const blue = Color.fromARGB(255, 4, 148, 208);
  static const green = Color.fromARGB(255, 54, 184, 58);
  static const orange = Color.fromARGB(255, 242, 184, 74);
  static const red = Color.fromARGB(255, 234, 89, 86);
  String get adultLabel {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Healthy';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color get adultColor {
    if (bmi < 18.5) return blue;
    if (bmi < 25) return green;
    if (bmi < 30) return orange;
    return red;
  }

  // --------------------------------------------------------------------------
  // CHILD BMI (PERCENTILE PLACEHOLDER)
  // NOTE: Replace with CDC/WHO tables later
  // --------------------------------------------------------------------------

  double get childPercentile {
    if (bmi < 14) return 3;
    if (bmi < 17) return 25;
    if (bmi < 20) return 50;
    if (bmi < 23) return 85;
    return 95;
  }

  String get childLabel {
    if (childPercentile < 5) return 'Underweight';
    if (childPercentile < 85) return 'Healthy';
    if (childPercentile < 95) return 'Overweight';
    return 'Obese';
  }

  Color get childColor {
    if (childPercentile < 5) return blue;
    if (childPercentile < 85) return green;
    if (childPercentile < 95) return orange;
    return red;
  }

  // --------------------------------------------------------------------------
  // INDICATOR POSITION (0–1)
  // --------------------------------------------------------------------------

  double get indicatorValue {
    if (isAdult) {
      const min = 14.0;
      const max = 40.0;
      return ((bmi.clamp(min, max) - min) / (max - min));
    } else {
      return childPercentile / 100;
    }
  }

  // --------------------------------------------------------------------------
  // UI
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final label = isAdult ? adultLabel : childLabel;
    final color = isAdult ? adultColor : childColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 360;
        final padding = isSmall ? 20.0 : 30.0;
        final titleSize = isSmall ? 16.0 : 18.0;
        final bmiSize = isSmall ? 24.0 : 28.0;

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: padding,
            horizontal: padding,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              Text(
                'Your BMI',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 8),

              // VALUE + LABEL (WRAPS SAFELY)
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Text(
                    bmi.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: bmiSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Your weight is',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: color,
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.help_outline,
                      size: 22,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // BMI BAR
              BmiLinearProgress(
                value: indicatorValue,
                blue: blue,
                green: green,
                orange: orange,
                red: red,
              ),

              const SizedBox(height: 20),

              // LEGEND (WRAPS ON SMALL SCREENS)
              const Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _Legend(color: blue, label: 'Underweight'),
                  _Legend(color: green, label: 'Healthy'),
                  _Legend(color: orange, label: 'Overweight'),
                  _Legend(color: red, label: 'Obese'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// BMI LINEAR BAR
// ============================================================================

class BmiLinearProgress extends StatelessWidget {
  final double value; // 0–1
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
        final indicatorX = constraints.maxWidth * value;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    blue, // Underweight
                    green, // Healthy
                    orange, // Overweight
                    red, // Obese
                  ],
                  stops: [0.0, 0.35, 0.65, 1.0],
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

// ============================================================================
// LEGEND
// ============================================================================

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
