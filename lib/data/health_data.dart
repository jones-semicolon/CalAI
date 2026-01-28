import 'package:calai/data/user_data.dart';
import 'package:flutter_riverpod/legacy.dart';

enum PortionType { tbsp, grams, serving, cup }

PortionType portionTypeFromLabel(String label) {
  final l = label.toLowerCase();
  if (l.contains("tbsp") || l.contains("tablespoon")) return PortionType.tbsp;
  if (l.contains("serving")) return PortionType.serving;
  if (l.contains("cup")) return PortionType.cup;

  // ✅ assume grams (fallback)
  return PortionType.grams;
}

class HealthData {
  // Goals
  final int calorieGoal;
  final int proteinGoal;
  final int carbsGoal;
  final int fatsGoal;
  final int fiberGoal;
  final int sugarGoal;
  final int sodiumGoal;

  // Daily Intake (Taken)
  final int dailyIntake;
  final int dailyWater;
  final int dailyBurned;
  final int dailyProtein;
  final int dailyCarbs;
  final int dailyFats;
  final int dailyFiber;
  final int dailySugar;
  final int dailySodium;

  // Others
  final WeightUnit weightUnit;

  const HealthData({
    this.calorieGoal = 0,
    this.proteinGoal = 0,
    this.carbsGoal = 0,
    this.fatsGoal = 0,
    this.fiberGoal = 0,
    this.sugarGoal = 0,
    this.sodiumGoal = 0,
    this.dailyIntake = 0,
    this.dailyWater = 0,
    this.dailyBurned = 0,
    this.dailyProtein = 0,
    this.dailyCarbs = 0,
    this.dailyFats = 0,
    this.dailyFiber = 0,
    this.dailySugar = 0,
    this.dailySodium = 0,
    this.weightUnit = WeightUnit.kg,
  });

  factory HealthData.initial() => const HealthData();

  HealthData copyWith({
    int? calorieGoal, int? proteinGoal, int? carbsGoal, int? fatsGoal,
    int? fiberGoal, int? sugarGoal, int? sodiumGoal,
    int? dailyIntake, int? dailyWater, int? dailyBurned,
    int? dailyProtein, int? dailyCarbs, int? dailyFats,
    int? dailyFiber, int? dailySugar, int? dailySodium,
    WeightUnit? weightUnit,
  }) {
    return HealthData(
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      fatsGoal: fatsGoal ?? this.fatsGoal,
      fiberGoal: fiberGoal ?? this.fiberGoal,
      sugarGoal: sugarGoal ?? this.sugarGoal,
      sodiumGoal: sodiumGoal ?? this.sodiumGoal,
      dailyIntake: dailyIntake ?? this.dailyIntake,
      dailyWater: dailyWater ?? this.dailyWater,
      dailyBurned: dailyBurned ?? this.dailyBurned,
      dailyProtein: dailyProtein ?? this.dailyProtein,
      dailyCarbs: dailyCarbs ?? this.dailyCarbs,
      dailyFats: dailyFats ?? this.dailyFats,
      dailyFiber: dailyFiber ?? this.dailyFiber,
      dailySugar: dailySugar ?? this.dailySugar,
      dailySodium: dailySodium ?? this.dailySodium,
      weightUnit: weightUnit ?? this.weightUnit,
    );
  }
}

class HealthDataNotifier extends StateNotifier<HealthData> {
  HealthDataNotifier() : super(HealthData.initial());

  void update(HealthData Function(HealthData state) transform) {
    state = transform(state);
  }

  void setDailySummary({
    required int intake,
    required int water,
    required int burned,
    required int p, required int c, required int f,
    required int fiber, required int sugar, required int sodium, required WeightUnit unit,
  }) {
    state = state.copyWith(
      dailyIntake: intake,
      dailyWater: water,
      dailyBurned: burned,
      dailyProtein: p,
      dailyCarbs: c,
      dailyFats: f,
      dailyFiber: fiber,
      dailySugar: sugar,
      dailySodium: sodium,
      weightUnit: unit,
    );
  }
}

final healthDataProvider = StateNotifierProvider<HealthDataNotifier, HealthData>((ref) {
  return HealthDataNotifier();
});