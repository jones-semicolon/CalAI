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
  final BoxDecoration? decoration;
  final bool? hasPadding;
  final VoidCallback? onTap;
  const ProgressBmiCard({super.key, this.decoration, this.hasPadding = true, this.onTap});

  int _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return 0;
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

    if (user.body.height == 0 || user.body.currentWeight == 0) {
      return const SizedBox.shrink();
    }

    // fallback weight
    final double weightKg = globalAsync.maybeWhen(
      data: (global) => global.weightLogs.isNotEmpty
          ? global.weightLogs.last.weight
          : user.body.currentWeight,
      orElse: () => user.body.currentWeight,
    );

    final bmi = _calculateBmi(
      weightKg: weightKg,
      heightCm: user.body.height.toDouble(),
    );

    final age = _calculateAge(user.profile.birthDate);
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
          padding: EdgeInsets.all(hasPadding! ? padding : 0),
          decoration: decoration ?? BoxDecoration(
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      bmi.isFinite ? bmi.toStringAsFixed(2) : "0.00",
                      style: TextStyle(
                        fontSize: bmiSize,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8), 
                    Text(
                      'Your weight is',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.shadowColor,
                      ),
                    ),
                    const SizedBox(width: 8), 
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
                    const SizedBox(width: 8), 
                    GestureDetector(
                      onTap: onTap,
                      child: Icon(
                        Icons.help_outline,
                        size: 22,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
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
                  fit: BoxFit.scaleDown, 
                  alignment: Alignment.centerLeft, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BmiLegend(color: BmiCalculator.blue, label: 'Underweight'),
                      const SizedBox(width: 8), 
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
