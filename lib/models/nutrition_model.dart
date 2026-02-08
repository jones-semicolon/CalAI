// models/nutrition_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Nutrition {
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final int fiber;
  final int sugar;
  final int sodium;
  final int water;
  final int steps;

  const Nutrition({
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fats = 0,
    this.fiber = 0,
    this.sugar = 0,
    this.sodium = 0,
    this.water = 0,
    this.steps = 0,
  });
}

class NutritionGoals extends Nutrition {
  // TODO must be weightGoal
  final int targetWeight;
  final int rollover;

  const NutritionGoals({
    super.calories,
    super.protein,
    super.carbs,
    super.fats,
    super.fiber,
    super.sugar,
    super.sodium,
    super.water,
    super.steps = 1000,
    this.targetWeight = 0, // ✅ Make it optional with a default
    this.rollover = 0,
  });

  factory NutritionGoals.fromJson(Map<String, dynamic> map) {
    // Use a nullable return type here
    int? val(String key) => (map[key] as num?)?.toInt();

    return NutritionGoals(
      calories: val('calorieGoal') ?? 0,
      protein: val('proteinGoal') ?? 0,
      carbs: val('carbsGoal') ?? 0,
      fats: val('fatsGoal') ?? 0,
      fiber: val('fiberGoal') ?? 0,
      sugar: val('sugarGoal') ?? 0,
      sodium: val('sodiumGoal') ?? 0,
      // TODO must be 64
      water: val('waterGoal') ?? 70,
      // TODO must be 10000
      steps: val('stepsGoal') ?? 1000,
      targetWeight: val('weightGoal') ?? 0 ,
      rollover: val('rollover') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'calorieGoal': calories,
    'proteinGoal': protein,
    'carbsGoal': carbs,
    'fatsGoal': fats,
    'fiberGoal': fiber,
    'sugarGoal': sugar,
    'sodiumGoal': sodium,
    'waterGoal': water,
    'stepsGoal': steps,
    'weightGoal': targetWeight,
    'rollover': rollover,
  };

  static const empty = NutritionGoals();

  NutritionGoals copyWith({
    int? calories,
    int? protein,
    int? carbs,
    int? fats,
    int? fiber,
    int? sugar,
    int? sodium,
    int? water,
    int? steps,
    int? targetWeight,
    int? rollover,
  }) {
    return NutritionGoals(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      water: water ?? this.water,
      steps: steps ?? this.steps,
      targetWeight: targetWeight ?? this.targetWeight,
      rollover: rollover ?? this.rollover,
    );
  }
}

class NutritionLog extends Nutrition {
  final DateTime date;

  const NutritionLog({
    required this.date,
    super.calories,
    super.protein,
    super.carbs,
    super.fats,
    super.fiber,
    super.sugar,
    super.sodium,
    super.water,
    super.steps,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'water': water,
      'steps': steps,
      'caloriesEaten': calories,
    };
  }

  // Helper to quickly convert a Firestore doc into a log entry for charts
  factory NutritionLog.fromSnapshot(DateTime date, Map<String, dynamic> data) {
    final dp = data['dailyProgress'] as Map<String, dynamic>? ?? {};

    int val(Map m, String k) => (m[k] as num?)?.toInt() ?? 0;

    return NutritionLog(
      date: date,
      calories: val(dp, 'caloriesEaten'),
      protein: val(dp, 'protein'),
      carbs: val(dp, 'carbs'),
      fats: val(dp, 'fats'),
      water: val(dp, 'water'),
      fiber: val(dp, 'fiber'),
      sugar: val(dp, 'sugar'),
      sodium: val(dp, 'sodium'),
      steps: val(dp, 'steps'),
    );
  }
}

class NutritionProgress extends Nutrition {
  final int caloriesBurned;

  const NutritionProgress({
    super.calories, super.protein, super.carbs, super.fats,
    super.fiber, super.sugar, super.sodium, super.water, this.caloriesBurned = 0, super.steps,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'water': water,
      'caloriesBurned': caloriesBurned,
      'steps': steps,
      'caloriesEaten': calories,
    };
  }

  factory NutritionProgress.fromDailyLog(Map<String, dynamic> data) {
    final dp = data['dailyProgress'] as Map<String, dynamic>? ?? {};

    int val(Map m, String k) => (m[k] as num?)?.toInt() ?? 0;

    return NutritionProgress(
      calories: val(dp, 'caloriesEaten'),
      protein: val(dp, 'protein'),
      carbs: val(dp, 'carbs'),
      fats: val(dp, 'fats'),
      water: val(dp, 'water'),
      fiber: val(dp, 'fiber'),
      sugar: val(dp, 'sugar'),
      sodium: val(dp, 'sodium'),
      caloriesBurned: val(dp, 'caloriesBurned'),
      steps: val(dp, 'steps'),
    );
  }

  static const empty = NutritionProgress();
}

class DailyNutrition {
  final int p; // Protein
  final int c; // Carbs
  final int f; // Fats
  final int kc;   // Total Calories
  final DateTime date;

  DailyNutrition({
    required this.p,
    required this.c,
    required this.f,
    required this.kc,
    required this.date
  });

  // Factory to create from Firestore map
  factory DailyNutrition.fromMap(Map<String, dynamic> data) {
    return DailyNutrition(
      p: (data['p'] ?? 0).toDouble(),
      c: (data['c'] ?? 0).toDouble(),
      f: (data['f'] ?? 0).toDouble(),
      kc: (data['kc'] ?? 0).toInt(),
      date: (data['date'] as Timestamp).toDate()
    );
  }

  Map<String, dynamic> toJson() => {
    'p': p,
    'c': c,
    'f': f,
    'kc': kc,
    'date': date.toIso8601String(),
  };

  DailyNutrition.empty() : this(p: 0, c: 0, f: 0, kc: 0, date: DateTime.now());
}

class WeeklyNutritionModel {
  final String weekId;
  final int lastWeekTotal;
  final Map<String, DailyNutrition> days;

  WeeklyNutritionModel({
    required this.weekId,
    required this.lastWeekTotal,
    required this.days,
  });

  factory WeeklyNutritionModel.fromMap(Map<String, dynamic> doc) {
    return WeeklyNutritionModel(
      weekId: doc['weekId'] ?? '',
      lastWeekTotal: (doc['lastWeekTotal'] ?? 0).toInt(),
      days: {
        'monday': DailyNutrition.fromMap(doc['monday'] ?? {}),
        'tuesday': DailyNutrition.fromMap(doc['tuesday'] ?? {}),
        'wednesday': DailyNutrition.fromMap(doc['wednesday'] ?? {}),
        'thursday': DailyNutrition.fromMap(doc['thursday'] ?? {}),
        'friday': DailyNutrition.fromMap(doc['friday'] ?? {}),
        'saturday': DailyNutrition.fromMap(doc['saturday'] ?? {}),
        'sunday': DailyNutrition.fromMap(doc['sunday'] ?? {}),
      },
    );
  }

  Map<String, dynamic> toJson() => {
    'weekId': weekId,
    'lastWeekTotal': lastWeekTotal,
    'monday': days['monday']?.toJson(),
    'tuesday': days['tuesday']?.toJson(),
    'wednesday': days['wednesday']?.toJson(),
    'thursday': days['thursday']?.toJson(),
    'friday': days['friday']?.toJson(),
    'saturday': days['saturday']?.toJson(),
    'sunday': days['sunday']?.toJson(),
    'updatedAt': FieldValue.serverTimestamp(),
  };

  // Helper to calculate this week's total for the "↓ 1%" comparison
  int get currentWeekTotal {
    return days.values.fold(0, (sum, day) => sum + day.kc);
  }
}
