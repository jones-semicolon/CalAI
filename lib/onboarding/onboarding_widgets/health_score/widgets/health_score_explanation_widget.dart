import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calai/l10n/l10n.dart';
import 'factors_card.dart';
import 'score_indicator.dart';

class HealthScoreExplanationWidget extends StatelessWidget {
  const HealthScoreExplanationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.healthScoreExplanationIntro,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.onPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.healthScoreExplanationFactorsLead,
          style: TextStyle(fontSize: 14, color: colors.onSecondary),
        ),
        const SizedBox(height: 20),
        FactorsCard(),
        const SizedBox(height: 28),
        ScoreIndicator(
          icon: FontAwesomeIcons.appleWhole,
          title: l10n.netCarbsLabel,
        ),
        const SizedBox(height: 15),
        ScoreIndicator(icon: Icons.grain, title: l10n.sodiumLabel),
      ],
    );
  }
}
