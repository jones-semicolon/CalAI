import '../models/goal_alert.dart';
import '../models/nutrition_intake_snapshot.dart';
import '../../../l10n/app_localizations.dart';

class GoalAlertEvaluator {
  const GoalAlertEvaluator({
    this.nearCalorieThreshold = 0.9,
    this.proteinLowThreshold = 0.8,
  });

  final double nearCalorieThreshold;
  final double proteinLowThreshold;

  List<GoalAlert> evaluate(
    NutritionIntakeSnapshot snapshot,
    AppLocalizations l10n,
  ) {
    final alerts = <GoalAlert>[];
    final goals = snapshot.goals;

    // Guard divide-by-zero when goals are not configured yet.
    final calorieProgress = goals.calories == 0
        ? 0.0
        : snapshot.consumedCalories / goals.calories;
    final proteinProgress = goals.protein == 0
        ? 0.0
        : snapshot.consumedProteinGrams / goals.protein;

    if (snapshot.consumedCalories > goals.calories) {
      alerts.add(
        GoalAlert(
          type: GoalAlertType.exceededCalorieLimit,
          title: l10n.alertCalorieGoalExceededTitle,
          body: l10n.alertCalorieGoalExceededBody(
            snapshot.consumedCalories - goals.calories,
          ),
        ),
      );
    } else if (calorieProgress >= nearCalorieThreshold) {
      final remaining = goals.calories - snapshot.consumedCalories;
      alerts.add(
        GoalAlert(
          type: GoalAlertType.nearCalorieLimit,
          title: l10n.alertNearCalorieLimitTitle,
          body: l10n.alertNearCalorieLimitBody(remaining),
        ),
      );
    }

    if (proteinProgress < proteinLowThreshold &&
        snapshot.consumedCalories >= (goals.calories * 0.6)) {
      // We only warn about low protein after enough calories are consumed.
      final missing = goals.protein - snapshot.consumedProteinGrams;
      alerts.add(
        GoalAlert(
          type: GoalAlertType.belowProteinTarget,
          title: l10n.alertProteinBehindTitle,
          body: l10n.alertProteinBehindBody(missing),
        ),
      );
    }

    if (snapshot.consumedCarbsGrams > goals.carbs) {
      alerts.add(
        GoalAlert(
          type: GoalAlertType.exceededCarbTarget,
          title: l10n.alertCarbTargetExceededTitle,
          body: l10n.alertCarbTargetExceededBody(
            snapshot.consumedCarbsGrams - goals.carbs,
          ),
        ),
      );
    }

    if (snapshot.consumedFatGrams > goals.fats) {
      alerts.add(
        GoalAlert(
          type: GoalAlertType.exceededFatTarget,
          title: l10n.alertFatTargetExceededTitle,
          body: l10n.alertFatTargetExceededBody(
            snapshot.consumedFatGrams - goals.fats,
          ),
        ),
      );
    }

    return alerts;
  }
}
