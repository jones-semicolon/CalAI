import 'package:flutter_riverpod/legacy.dart';

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
  });

  factory HealthData.initial() => const HealthData();

  HealthData copyWith({
    int? calorieGoal, int? proteinGoal, int? carbsGoal, int? fatsGoal,
    int? fiberGoal, int? sugarGoal, int? sodiumGoal,
    int? dailyIntake, int? dailyWater, int? dailyBurned,
    int? dailyProtein, int? dailyCarbs, int? dailyFats,
    int? dailyFiber, int? dailySugar, int? dailySodium,
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
    int? fiber, int? sugar, int? sodium,
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
    );
  }
}

final healthDataProvider = StateNotifierProvider<HealthDataNotifier, HealthData>((ref) {
  return HealthDataNotifier();
});

enum WeightUnit {kg, lbs}