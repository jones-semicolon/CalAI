import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'factors_card.dart';
import 'score_indicator.dart';

class HealthScoreExplanationWidget extends StatelessWidget {
  const HealthScoreExplanationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our health score is a complex formula taking into account '
          'several factors given a multitude of common foods.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.onPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Below are the factors we take into account when calculating health score:',
          style: TextStyle(fontSize: 14, color: colors.onSecondary),
        ),
        const SizedBox(height: 20),
        const FactorsCard(),
        const SizedBox(height: 28),
        const ScoreIndicator(
          icon: FontAwesomeIcons.appleWhole,
          title: 'Net carbs',
        ),
        const SizedBox(height: 15),
        const ScoreIndicator(icon: Icons.grain, title: 'Sodium'),
      ],
    );
  }
}
