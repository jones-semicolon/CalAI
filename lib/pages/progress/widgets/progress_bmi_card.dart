import 'package:calai/core/constants/constants.dart';
import 'package:calai/pages/progress/bmi_calculator.dart';
import 'package:calai/pages/progress/widgets/bmi_legend.dart';
import 'package:calai/pages/progress/widgets/bmi_linear_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enums/user_enums.dart';
import '../../../providers/global_provider.dart';
import '../../../providers/user_provider.dart';

class ProgressBmiCard extends ConsumerWidget {
  const ProgressBmiCard({super.key});

  int _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return 0; // Guard for null birthDate
    final today = DateTime.now();
    var age = today.year - birthDate.year;

    final birthdayThisYear = DateTime(today.year, birthDate.month, birthDate.day);
    if (today.isBefore(birthdayThisYear)) age--;

    return age;
  }

  double _calculateBmi({required double weightKg, required double heightCm}) {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(userProvider);
    final globalAsync = ref.watch(globalDataProvider);

    // ✅ MODIFIED GUARD: Only hide if we can't do the math (Weight/Height)
    // We provide a fallback for gender/birthday so the card still shows.
    if (user.body.height == 0 || user.body.currentWeight == 0) {
      return const SizedBox.shrink();
    }

    // fallback weight
    double weightKg = user.body.currentWeight;

    // take latest logged weight if available
    globalAsync.whenData((global) {
      if (global.weightLogs.isNotEmpty) {
        weightKg = global.weightLogs.last.weight;
      }
    });

    final bmi = _calculateBmi(
      weightKg: weightKg,
      heightCm: user.body.height.toDouble(),
    );

    // Handle null age safely
    final age = _calculateAge(user.profile.birthDate);

    // Provide a default gender if null so BmiCalculator doesn't crash
    final gender = user.profile.gender ?? Gender.other;

    final calculator = BmiCalculator(
      bmi: bmi,
      age: age,
      gender: gender,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 360;
        final padding = isSmall ? 20.0 : 30.0;
        final titleSize = isSmall ? 16.0 : 18.0;
        final bmiSize = isSmall ? 24.0 : 28.0;

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your BMI',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Text(
                    bmi.isFinite ? bmi.toStringAsFixed(2) : "0.00",
                    style: TextStyle(
                      fontSize: bmiSize,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Your weight is',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.shadowColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      color: calculator.color,
                    ),
                    child: Text(
                      calculator.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // TODO move it to BMI info page
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("BMI Information"),
                          content: const Text(
                            "BMI is an estimate of body fat based on height and weight.\n\n"
                                "Underweight: < 18.5\n"
                                "Healthy: 18.5 – 24.9\n"
                                "Overweight: 25 – 29.9\n"
                                "Obese: 30+",
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.help_outline,
                      size: 22,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // // ✅ show the weight used (optional, remove if you want)
              // Text(
              //   "Based on: ${weightKg.toStringAsFixed(1)} kg",
              //   style: const TextStyle(
              //     fontSize: 12,
              //     color: Color.fromARGB(255, 137, 137, 139),
              //   ),
              // ),

              const SizedBox(height: 14),
              BmiLinearProgress(
                value: calculator.indicatorValue,
                blue: BmiCalculator.blue,
                green: BmiCalculator.green,
                orange: BmiCalculator.orange,
                red: BmiCalculator.red,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.scaleDown, // Shrinks the content only if it's too wide
                  alignment: Alignment.centerLeft, // Keeps the legends starting from the left
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BmiLegend(color: BmiCalculator.blue, label: 'Underweight'),
                      const SizedBox(width: 8), // Replaces 'spacing' from Wrap
                      BmiLegend(color: BmiCalculator.green, label: 'Healthy'),
                      const SizedBox(width: 8),
                      BmiLegend(color: BmiCalculator.orange, label: 'Overweight'),
                      const SizedBox(width: 8),
                      BmiLegend(color: BmiCalculator.red, label: 'Obese'),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
