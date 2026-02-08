import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Intensity {
  low,
  medium,
  high;

  // Helper to parse string from API (e.g., "Low" -> Intensity.low)
  static Intensity fromString(String value) {
    return Intensity.values.firstWhere(
          (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Intensity.low,
    );
  }

  // Helper to get capital case string for UI (e.g., Intensity.low -> "Low")
  String get label => name[0].toUpperCase() + name.substring(1);
}

enum ExerciseType {
  run,
  weightLifting,
  walking,
  cycling,
  swimming,
  jumpRope,
  yoga,
  hiking,
  unknown;

  // 1. Helper to get the correct icon
  IconData get icon {
    switch (this) {
      case ExerciseType.run:
        return Icons.directions_run;
      case ExerciseType.weightLifting:
        return Icons.fitness_center;
      case ExerciseType.walking:
        return Icons.directions_walk;
      case ExerciseType.cycling:
        return Icons.directions_bike;
      case ExerciseType.swimming:
        return Icons.pool;
      case ExerciseType.jumpRope:
        return Icons.sports_gymnastics; // Best fit for jumping/agility
      case ExerciseType.yoga:
        return Icons.self_improvement;
      case ExerciseType.hiking:
        return Icons.hiking;
      case ExerciseType.unknown:
        return Icons.electric_bolt;
    }
  }

  // 2. Helper to get a pretty UI label
  String get label {
    switch (this) {
      case ExerciseType.run:
        return "Run";
      case ExerciseType.weightLifting:
        return "Weight Lifting";
      case ExerciseType.walking:
        return "Walking";
      case ExerciseType.cycling:
        return "Cycling";
      case ExerciseType.swimming:
        return "Swimming";
      case ExerciseType.jumpRope:
        return "Jump Rope";
      case ExerciseType.yoga:
        return "Yoga";
      case ExerciseType.hiking:
        return "Hiking";
      case ExerciseType.unknown:
        return "Activity";
    }
  }

  // 3. Helper to parse from String (Case insensitive)
  static ExerciseType fromString(String? value) {
    if (value == null) return ExerciseType.unknown;

    // Normalize string (e.g. "Weight Lifting" -> "weightlifting")
    final normalized = value.replaceAll(' ', '').toLowerCase();

    return ExerciseType.values.firstWhere(
          (e) => e.name.toLowerCase() == normalized,
      orElse: () => ExerciseType.unknown,
    );
  }
}