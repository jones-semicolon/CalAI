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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
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
          // ---------------- TITLE ----------------
          Text(
            'Your BMI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: 5),

          // ---------------- VALUE ROW ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                bmi.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                'Your weight is',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).shadowColor,
                ),
              ),

              const SizedBox(width: 5),

              // BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: color,
                ),
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),

              const Spacer(),

              // HELP ICON
              GestureDetector(
                onTap: () {
                  //function
                },
                child: Icon(
                  Icons.help_outline,
                  size: 22,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------- BMI BAR ----------------
          BmiLinearProgress(
            value: indicatorValue,
            blue: blue,
            green: green,
            orange: orange,
            red: red,
          ),

          const SizedBox(height: 20),

          // ---------------- LEGEND ----------------
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  color: Theme.of(context).colorScheme.onPrimary,
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

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
