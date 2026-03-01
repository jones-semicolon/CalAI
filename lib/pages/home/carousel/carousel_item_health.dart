import 'package:calai/l10n/l10n.dart';
import 'package:calai/pages/home/health_score/health_score_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enums/food_enums.dart';
import '../../../models/nutrition_model.dart';
import '../../../providers/global_provider.dart';
import '../../../providers/user_provider.dart';
import '../widgets/activity_card.dart';

class CarouselHealth extends ConsumerWidget {
  final bool isTap;
  final VoidCallback onTap;

  const CarouselHealth({
    super.key,
    required this.isTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalState = ref.watch(globalDataProvider).value;
    final progress = globalState?.todayProgress ?? NutritionProgress.empty;

    final user = ref.watch(userProvider);
    final targets = user.goal.targets;

    double calculateScore() {
      if (targets.fiber == 0) return 0.0;
      final fiberScore = (progress.fiber / targets.fiber).clamp(0.0, 1.0);
      final sodiumScore =
          (1.0 - (progress.sodium / targets.sodium)).clamp(0.0, 1.0);
      return (fiberScore + sodiumScore) / 2 * 10;
    }

    final currentScore = calculateScore();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            _NutrientCardsRow(
              progress: progress,
              targets: targets,
              isTap: isTap,
            ),
            const SizedBox(height: 10),
            _HealthScoreCard(
              protein: progress.protein,
              calories: progress.calories,
              score: currentScore,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthScoreView(score: currentScore),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientCardsRow extends StatelessWidget {
  final bool isTap;
  final NutritionGoals targets;
  final NutritionProgress progress;

  const _NutrientCardsRow({
    required this.isTap,
    required this.targets,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CalorieCard(
            title: context.l10n.fiberLabel,
            nutrients: targets.fiber,
            progress: progress.fiber,
            color: MicroNutritionType.fiber.color,
            icon: MicroNutritionType.fiber.icon,
            unit: 'g',
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: context.l10n.sugarLabel,
            nutrients: targets.sugar,
            progress: progress.sugar,
            color: MicroNutritionType.sugar.color,
            icon: MicroNutritionType.sugar.icon,
            unit: 'g',
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: context.l10n.sodiumLabel,
            nutrients: targets.sodium,
            progress: progress.sodium,
            color: MicroNutritionType.sodium.color,
            icon: MicroNutritionType.sodium.icon,
            unit: 'mg',
            isTap: isTap,
          ),
        ),
      ],
    );
  }
}

class _HealthScoreCard extends StatelessWidget {
  final double score;
  final double protein;
  final double calories;
  final VoidCallback onTap;

  const _HealthScoreCard({
    required this.score,
    required this.protein,
    required this.calories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final summaryMessage = _getHealthSummary(context, score, protein, calories);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.healthScoreTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${score.toStringAsFixed(0)}/10',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onTertiary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (score / 10).clamp(0.0, 1.0),
                  color: const Color.fromARGB(255, 132, 224, 125),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              summaryMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getHealthSummary(
  BuildContext context,
  double score,
  double protein,
  double calories,
) {
  if (score == 0) {
    return context.l10n.healthSummaryNoData;
  }

  if (score < 5) {
    return context.l10n.healthSummaryLowIntake;
  }

  if (protein < 30) {
    return context.l10n.healthSummaryLowProtein;
  }

  return context.l10n.healthSummaryGreat;
}
