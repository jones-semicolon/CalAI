import 'package:calai/core/constants/constants.dart';
import 'package:calai/pages/progress/bmi_calculator.dart';
import 'package:calai/pages/progress/progress_data_provider.dart';
import 'package:calai/pages/progress/widgets/bmi_legend.dart';
import 'package:calai/pages/progress/widgets/bmi_linear_progress.dart';
import 'package:flutter/material.dart';

/// A card that displays the user's Body Mass Index (BMI) and its interpretation.
///
/// This widget is purely for presentation. It uses a [BmiCalculator] to get
/// all the necessary values and logic, and then lays out the UI using
/// sub-widgets like [BmiLinearProgress] and [BmiLegend].
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

  @override
  Widget build(BuildContext context) {
    // All complex logic is handled by the calculator.
    final calculator = BmiCalculator(bmi: bmi, age: age, sex: sex);
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive layout adjustments remain here.
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
                    bmi.toStringAsFixed(2),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      color: calculator.color, // From calculator
                    ),
                    child: Text(
                      calculator.label, // From calculator
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement help dialog or info screen
                    },
                    child: Icon(
                      Icons.help_outline,
                      size: 22,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BmiLinearProgress(
                value: calculator.indicatorValue, // From calculator
                blue: BmiCalculator.blue,
                green: BmiCalculator.green,
                orange: BmiCalculator.orange,
                red: BmiCalculator.red,
              ),
              const SizedBox(height: 20),
              const Wrap(
                spacing: 12,
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
