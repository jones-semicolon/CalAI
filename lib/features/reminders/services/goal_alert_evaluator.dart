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
          title: 'Calorie goal exceeded',
          body:
              'You are ${snapshot.consumedCalories - goals.calories} kcal over your daily target.',
        ),
      );
    } else if (calorieProgress >= nearCalorieThreshold) {
      final remaining = goals.calories - snapshot.consumedCalories;
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
        snapshot.consumedCalories >= (goals.calories * 0.6)) {
      // We only warn about low protein after enough calories are consumed.
      final missing = goals.protein - snapshot.consumedProteinGrams;
      alerts.add(
        GoalAlert(
          type: GoalAlertType.belowProteinTarget,
          title: 'Protein target is behind',
          body:
              'You still need about $missing g protein to hit today\'s target.',
        ),
      );
    }

    if (snapshot.consumedCarbsGrams > goals.carbs) {
      alerts.add(
        GoalAlert(
          type: GoalAlertType.exceededCarbTarget,
          title: 'Carb target exceeded',
          body:
              'Carbs are ${snapshot.consumedCarbsGrams - goals.carbs} g over target.',
        ),
      );
    }

    if (snapshot.consumedFatGrams > goals.fats) {
      alerts.add(
        GoalAlert(
          type: GoalAlertType.exceededFatTarget,
          title: 'Fat target exceeded',
          body:
              'Fat is ${snapshot.consumedFatGrams - goals.fats} g over target.',
        ),
      );
    }

    return alerts;
  }
}
