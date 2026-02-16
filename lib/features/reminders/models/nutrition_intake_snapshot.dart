import 'nutrition_goals.dart';

class NutritionIntakeSnapshot {
  const NutritionIntakeSnapshot({
    required this.consumedCalories,
    required this.consumedProteinGrams,
    required this.consumedCarbsGrams,
    required this.consumedFatGrams,
    required this.goals,
  });

  final int consumedCalories;
  final int consumedProteinGrams;
  final int consumedCarbsGrams;
  final int consumedFatGrams;
  final NutritionGoals goals;

  int get caloriesRemaining => goals.calorieGoal - consumedCalories;
  int get proteinRemaining => goals.proteinGoalGrams - consumedProteinGrams;
}
