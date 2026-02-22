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

  double get caloriesRemaining => goals.calories - consumedCalories;
  double get proteinRemaining => goals.protein - consumedProteinGrams;
}
