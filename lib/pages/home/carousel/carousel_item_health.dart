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
  // Use the HealthData state object directly

  const CarouselHealth({
    super.key,
    required this.isTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get Today's Progress from Global State
    final globalState = ref.watch(globalDataProvider).value;
    final progress = globalState?.todayProgress ?? NutritionProgress.empty;

    // 2. Get Targets from User Model
    final user = ref.watch(userProvider);
    final targets = user.goal.targets;

    double calculateScore() {
      if (targets.fiber == 0) return 0.0;
      double fiberScore = (progress.fiber / targets.fiber).clamp(0.0, 1.0);
      double sodiumScore = (1.0 - (progress.sodium / targets.sodium)).clamp(0.0, 1.0);
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HealthScoreView(score: currentScore)));
                debugPrint("Navigating to Health Score Page...");
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
            title: MicroNutritionType.fiber.label,
            nutrients: targets.fiber, // Goal from HealthData
            progress: progress.fiber, // Intake from HealthData
            color: MicroNutritionType.fiber.color,
            icon: MicroNutritionType.fiber.icon,
            unit: "g",
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: MicroNutritionType.sugar.label,
            nutrients: targets.sugar,
            progress: progress.sugar,
            color: MicroNutritionType.sugar.color,
            icon: MicroNutritionType.sugar.icon,
            unit: "g",
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: MicroNutritionType.sodium.label,
            nutrients: targets.sodium,
            progress: progress.sodium,
            color: MicroNutritionType.sodium.color,
            icon: MicroNutritionType.sodium.icon,
            unit: "mg",
            isTap: isTap,
          ),
        ),
      ],
    );
  }
}

/// Displays the "Health Score" card with its progress bar and summary text.
class _HealthScoreCard extends StatelessWidget {
  final double score;
  final double protein; // Added
  final double calories; // Added
  final VoidCallback onTap;

  const _HealthScoreCard({
    required this.score,
    required this.protein,
    required this.calories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate the message based on current data
    final String summaryMessage = _getHealthSummary(score, protein, calories);

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
                  'Health score',
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
              summaryMessage, // ✅ Displays the dynamic summary
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

String _getHealthSummary(double score, double protein, double calories) {
  if (score == 0) {
    return 'No data logged for today. Start tracking your meals to see your health insights!';
  }

  if (score < 5) {
    return 'Your intake is quite low. Focus on hitting your calorie and protein targets to maintain energy and muscle.';
  }

  // Example of specific macro feedback
  if (protein < 30) {
    return 'Carbs and fat are on track, but you’re low in protein. Increasing protein can help with muscle retention.';
  }

  return 'Great job! Your nutrition is well-balanced today.';
}