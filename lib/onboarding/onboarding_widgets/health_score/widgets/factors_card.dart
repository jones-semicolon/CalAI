import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calai/l10n/l10n.dart';
import 'factor_row.dart';

class FactorsCard extends StatelessWidget {
  const FactorsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.secondaryFixed, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                FactorRow(
                  icon: FontAwesomeIcons.appleWhole,
                  title: l10n.factorsNetCarbsMass,
                  subtitle: l10n.factorsNetCarbDensity,
                ),
                FactorRow(
                  icon: Icons.grain,
                  title: l10n.factorsSodiumMass,
                  subtitle: l10n.factorsSodiumDensity,
                ),
                FactorRow(
                  icon: Icons.icecream,
                  title: l10n.factorsSugarMass,
                  subtitle: l10n.factorsSugarDensity,
                ),
                FactorRow(
                  icon: Icons.science,
                  title: l10n.factorsProcessedScore,
                  subtitle: l10n.factorsIngredientQuality,
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
              l10n.factorsProcessedScoreDescription,
              style: TextStyle(fontSize: 11, color: colors.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
