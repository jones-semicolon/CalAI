import '../models/goal_alert.dart';
import '../models/nutrition_intake_snapshot.dart';

class GoalAlertEvaluator {
  const GoalAlertEvaluator({
    this.nearCalorieThreshold = 0.9,
    this.proteinLowThreshold = 0.8,
  });

  final double nearCalorieThreshold;
  final double proteinLowThreshold;

  List<GoalAlert> evaluate(NutritionIntakeSnapshot snapshot) {
    final alerts = <GoalAlert>[];
    final goals = snapshot.goals;

    // Guard divide-by-zero when goals are not configured yet.
    final calorieProgress = goals.calorieGoal == 0
        ? 0.0
        : snapshot.consumedCalories / goals.calorieGoal;
    final proteinProgress = goals.proteinGoalGrams == 0
        ? 0.0
        : snapshot.consumedProteinGrams / goals.proteinGoalGrams;

    if (snapshot.consumedCalories > goals.calorieGoal) {
      alerts.add(
        GoalAlert(
          type: GoalAlertType.exceededCalorieLimit,
          title: 'Calorie goal exceeded',
          body:
              'You are ${snapshot.consumedCalories - goals.calorieGoal} kcal over your daily target.',
        ),
      );
    } else if (calorieProgress >= nearCalorieThreshold) {
      final remaining = goals.calorieGoal - snapshot.consumedCalories;
      alerts.add(
        GoalAlert(
          type: GoalAlertType.nearCalorieLimit,
          title: 'You are near your calorie limit',
          body:
              'Only $remaining kcal left today. Plan your next meal carefully.',
        ),
      );
    }

    if (proteinProgress < proteinLowThreshold &&
        snapshot.consumedCalories >= (goals.calorieGoal * 0.6)) {
      // We only warn about low protein after enough calories are consumed.
      final missing = goals.proteinGoalGrams - snapshot.consumedProteinGrams;
      alerts.add(
        GoalAlert(
          type: GoalAlertType.belowProteinTarget,
          title: 'Protein target is behind',
          body:
              'You still need about $missing g protein to hit today\'s target.',
        ),
      );
    }

    if (snapshot.consumedCarbsGrams > goals.carbGoalGrams) {
      alerts.add(
        GoalAlert(
          type: GoalAlertType.exceededCarbTarget,
          title: 'Carb target exceeded',
          body:
              'Carbs are ${snapshot.consumedCarbsGrams - goals.carbGoalGrams} g over target.',
        ),
      );
    }

    if (snapshot.consumedFatGrams > goals.fatGoalGrams) {
      alerts.add(
        GoalAlert(
          type: GoalAlertType.exceededFatTarget,
          title: 'Fat target exceeded',
          body:
              'Fat is ${snapshot.consumedFatGrams - goals.fatGoalGrams} g over target.',
        ),
      );
    }

    return alerts;
  }
}
