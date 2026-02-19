import '../../../models/nutrition_model.dart';

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

  int get caloriesRemaining => goals.calories.round() - consumedCalories;
  int get proteinRemaining => goals.protein.round() - consumedProteinGrams;
}
