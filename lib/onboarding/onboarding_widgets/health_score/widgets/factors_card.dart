import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'factor_row.dart';

class FactorsCard extends StatelessWidget {
  const FactorsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.secondaryFixed, width: 1),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                FactorRow(
                  icon: FontAwesomeIcons.appleWhole,
                  title: 'Net carbs / mass',
                  subtitle: 'Net carb density',
                ),
                FactorRow(
                  icon: Icons.grain,
                  title: 'Sodium / mass',
                  subtitle: 'Sodium density',
                ),
                FactorRow(
                  icon: Icons.icecream,
                  title: 'Sugar / mass',
                  subtitle: 'Sugar density',
                ),
                FactorRow(
                  icon: Icons.science,
                  title: 'Processed score',
                  subtitle: 'Ingredient quality',
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'The processed score takes into account dyes, nitrates, seed oils, '
              'artificial flavoring / sweeteners, and other factors.',
              style: TextStyle(fontSize: 11, color: colors.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
