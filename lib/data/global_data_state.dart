import 'package:flutter/foundation.dart';

@immutable
class GlobalDataState {
  final bool isInitialized;
  final String activeDateId;

  // ✅ Progress graph cache
  final List<Map<String, dynamic>> weightLogs; // [{date: DateTime, weight: double}]
  final double goalWeight;
  final Set<String> progressDays;
  final List<Map<String, dynamic>> calorieLogs;
  final double calorieGoal;
  final Set<String> overDays;
  final Map<String, double> dailyCalories; // key = "YYYY-MM-DD"\


  const GlobalDataState({
    required this.isInitialized,
    required this.activeDateId,
    required this.weightLogs,
    required this.goalWeight,
    required this.progressDays,
    required this.calorieLogs,
    required this.calorieGoal, required this.overDays, required this.dailyCalories,
  });

  factory GlobalDataState.initial() => GlobalDataState(
    isInitialized: false,
    activeDateId: DateTime.now().toIso8601String().split('T').first,
    weightLogs: const [],
    goalWeight: 0,
    progressDays: const {},
    calorieLogs: const [],
    calorieGoal: 0,
    overDays: <String>{},
    dailyCalories: const {},
  );


  GlobalDataState copyWith({
    bool? isInitialized,
    String? activeDateId,
    List<Map<String, dynamic>>? weightLogs,
    double? goalWeight,
    Set<String>? progressDays,
    List<Map<String, dynamic>>? calorieLogs,
    double? calorieGoal,
    Set<String>? overDays,
    Map<String, double>? dailyCalories,
  }) {
    return GlobalDataState(
      isInitialized: isInitialized ?? this.isInitialized,
      activeDateId: activeDateId ?? this.activeDateId,
      weightLogs: weightLogs ?? this.weightLogs,
      goalWeight: goalWeight ?? this.goalWeight,
      progressDays: progressDays ?? this.progressDays,
      calorieLogs: calorieLogs ?? this.calorieLogs,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      overDays: overDays ?? this.overDays,
      dailyCalories: dailyCalories ?? this.dailyCalories,
    );
  }
}