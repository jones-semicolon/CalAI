import 'package:calai/core/constants/constants.dart';
import 'package:calai/pages/progress/bmi_calculator.dart';
import 'package:calai/pages/progress/widgets/bmi_legend.dart';
import 'package:calai/pages/progress/widgets/bmi_linear_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/global_data.dart';
import '../../../data/user_data.dart';

class ProgressBmiCard extends ConsumerWidget {
  const ProgressBmiCard({super.key});

  int _calculateAge(DateTime birthDate) {
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

    // ✅ fallback weight = user profile weight
    double weightKg = user.weight;

    // ✅ if progress logs exist, take the latest logged weight
    globalAsync.whenData((global) {
      if (global.weightLogs.isNotEmpty) {
        final last = global.weightLogs.last;
        final w = last['weight'];
        if (w is num) weightKg = w.toDouble();
      }
    });

    final bmi = _calculateBmi(
      weightKg: weightKg,
      heightCm: user.height.toDouble(),
    );

    final age = _calculateAge(user.birthDay);

    final calculator = BmiCalculator(
      bmi: bmi,
      age: age,
      gender: user.gender,
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
              const Wrap(
                spacing: 5,
                runSpacing: 8,
                children: [
                  BmiLegend(color: BmiCalculator.blue, label: 'Underweight'),
                  BmiLegend(color: BmiCalculator.green, label: 'Healthy'),
                  BmiLegend(color: BmiCalculator.orange, label: 'Overweight'),
                  BmiLegend(color: BmiCalculator.red, label: 'Obese'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
