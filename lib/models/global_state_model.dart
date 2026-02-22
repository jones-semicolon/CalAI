import 'package:calai/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:calai/models/nutrition_model.dart';
import '../enums/food_enums.dart';
import 'exercise_model.dart';

@immutable
class GlobalDataState {
  final bool isInitialized;
  final String activeDateId;

  // Holds today's live stats (Protein, Cals, Water, etc.)
  final NutritionProgress todayProgress;
  final NutritionGoals todayGoal;

  // ✅ UPDATED: Specifically for tracking daily totals (p, c, kc, f, date)
  final List<DailyNutrition> dailyNutrition;
  final List<WeightLog> weightLogs;

  // Metadata for Calendar dots and history
  final Set<String> progressDays;
  final UserSettings userSettings;

  const GlobalDataState({
    required this.isInitialized,
    required this.activeDateId,
    required this.todayProgress,
    required this.weightLogs,
    required this.progressDays,
    required this.dailyNutrition, // ✅ Updated field
    required this.todayGoal,
    required this.userSettings
  });

  factory GlobalDataState.initial() => GlobalDataState(
    isInitialized: false,
    activeDateId: DateTime.now().toIso8601String().split('T').first,
    todayProgress: NutritionProgress.empty,
    weightLogs: const [],
    progressDays: const {},
    dailyNutrition: const [], // ✅ Updated field
    todayGoal: NutritionGoals.empty,
    userSettings: UserSettings.defaultSettings,
  );

  // --- Dynamic Dashboard Logic ---

  num effectiveCalorieGoal(bool isAddCalorieBurnEnabled, bool isRolloverEnabled) {
    // Prioritizes today's log goal, falls back to master profile goal
    final num baseGoal = (todayGoal.calories > 0) ? todayGoal.calories : 0;

    num total = baseGoal;
    if (isRolloverEnabled) total += todayGoal.rollover;
    if (isAddCalorieBurnEnabled) total += todayProgress.caloriesBurned;

    return total;
  }

  num caloriesRemaining(bool isAddCalorieBurnEnabled, bool isRolloverEnabled) {
    return effectiveCalorieGoal(isAddCalorieBurnEnabled, isRolloverEnabled) - todayProgress.calories;
  }

  double calorieProgress(bool isAddCalorieBurnEnabled, bool isRolloverEnabled) {
    final num target = effectiveCalorieGoal(isAddCalorieBurnEnabled, isRolloverEnabled);
    if (target == 0) return 0.0;
    return (todayProgress.calories / target).clamp(0.0, 1.0);
  }

  // --- Persistence & Debug Support ---

  Map<String, dynamic> toJson() {
    return {
      'isInitialized': isInitialized,
      'activeDateId': activeDateId,
      'todayProgress': todayProgress.toJson(),
      'weightLogs': weightLogs.map((e) => e.toJson()).toList(),
      'progressDays': progressDays.toList(),
      'dailyNutrition': dailyNutrition.map((e) => e.toJson()).toList(), // ✅ Updated
      'todayGoal': todayGoal.toJson(),
      'userSettings': userSettings.toJson(),
    };
  }

  GlobalDataState copyWith({
    bool? isInitialized,
    String? activeDateId,
    NutritionProgress? todayProgress,
    List<WeightLog>? weightLogs,
    double? goalWeight,
    Set<String>? progressDays,
    List<DailyNutrition>? dailyNutrition, // ✅ Updated
    double? calorieGoal,
    NutritionGoals? todayGoal,
    UserSettings? userSettings,
  }) {
    return GlobalDataState(
      isInitialized: isInitialized ?? this.isInitialized,
      activeDateId: activeDateId ?? this.activeDateId,
      todayProgress: todayProgress ?? this.todayProgress,
      weightLogs: weightLogs ?? this.weightLogs,
      progressDays: progressDays ?? this.progressDays,
      dailyNutrition: dailyNutrition ?? this.dailyNutrition,
      todayGoal: todayGoal ?? this.todayGoal,
      userSettings: userSettings ?? this.userSettings,
    );
  }
}
