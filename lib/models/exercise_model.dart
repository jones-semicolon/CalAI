import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../enums/exercise_enums.dart';

abstract class Exercise {
  final ExerciseType type;           // e.g., "Run"
  final Intensity intensity;   // e.g., Intensity.low
  final int durationMins;      // e.g., 30
  final double caloriesBurned;    // e.g., 221 (nullable if not calculated yet)

  Exercise({
    required this.type,
    required this.intensity,
    required this.durationMins,
    required this.caloriesBurned,
  });
}

@immutable
class ExerciseModel extends Exercise {
  ExerciseModel({
    required super.type,
    required super.intensity,
    required super.durationMins,
    required super.caloriesBurned,
  });

  ExerciseLog createLog({
    required double amount,
    required String unit,
    required double gramWeight,
  }) {
    return ExerciseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      intensity: intensity,
      durationMins: durationMins,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
    );
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      type: ExerciseType.fromString(json['exerciseType']?.toString() ?? ""),
      // ✅ Safety check for intensity string
      intensity: Intensity.fromString(json['intensity']?.toString() ?? "Low"),
      // ✅ Use num? casting to prevent Null crashes
      durationMins: (json['duration_mins'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['calories_burned'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseType': type,
      'intensity': intensity.label, // Sends "Low", "Medium", etc.
      'durationMins': durationMins,
      'caloriesBurned': caloriesBurned,
    };
  }
}

@immutable
class ExerciseLog extends Exercise {
  final String id;
  final DateTime? timestamp;
  final double? weightKg;

  ExerciseLog({
    required this.id,
    required super.type,
    required super.intensity,
    required super.durationMins,
    required super.caloriesBurned,
    required this.timestamp,
    this.weightKg
  });

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      id: json['id']?.toString() ?? '',
      type: ExerciseType.fromString(json['exercise_type']?.toString() ?? ""),
      // ✅ Handle potential null strings
      intensity: Intensity.fromString(json['intensity']?.toString() ?? "Low"),
      // ✅ Safe numeric parsing
      durationMins: (json['duration_mins'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['calories_burned'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : (json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null),
      weightKg: (json['meta']?['weight_used'] as num?)?.toDouble() ?? 0.0
    );
  }
  // Convert instance to JSON (for API requests or local storage)
  Map<String, dynamic> toJson() {
    return {
      'exercise_type': type.name,
      'intensity': intensity.name, // Sends "Low", "Medium", etc.
      'duration_mins': durationMins,
      'timestamp': timestamp?.toIso8601String(),
      'calories_burned': caloriesBurned,
      'weight': weightKg,
    };
  }

  // UI Helper: Returns "9:42 AM"
  String get formattedTime {
    if (timestamp == null) return '--:--'; // Or "Pending"
    return DateFormat.jm().format(timestamp!);
  }

  ExerciseLog copyWith({
    String? id,
    ExerciseType? type,
    Intensity? intensity,
    int? durationMins,
    double? caloriesBurned,
    DateTime? timestamp,
    double? weightKg,
  }) {
    return ExerciseLog(
      id: id ?? this.id,
      type: type ?? this.type,
      intensity: intensity ?? this.intensity,
      durationMins: durationMins ?? this.durationMins,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
      weightKg: weightKg ?? this.weightKg,
    );
  }
}

class WeightLog {
  final DateTime date;
  final double weight;
  const WeightLog({required this.date, required this.weight});

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'w': weight,
    };
  }
}

class CalorieLog {
  final DateTime date;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  const CalorieLog({
    required this.date,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fats = 0,
  });
}