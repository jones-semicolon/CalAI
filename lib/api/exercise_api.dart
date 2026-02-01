import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

class ExerciseApi {
  static const _host = "cal-ai-liard.vercel.app";

  // Renamed to match the functionality (logging an exercise)
  // and updated arguments to match the POST route requirements.
  Future<Map<String, dynamic>> getBurnedCalories({
    required double weightKg,
    String exerciseType = "run",
    String intensity = "low",
    int durationMins = 0,
    String description = "",
  }) async {
    final uri = Uri.https(_host, '/log-exercise');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: durationMins == 0 ? jsonEncode({'weight_kg': weightKg, 'description': description}) : jsonEncode({
          'weight_kg': weightKg,
          'exercise_type': exerciseType,
          'intensity': intensity,
          'duration_mins': durationMins,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Return the decoded JSON response (e.g., burned calories info)
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to log exercise: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error logging exercise: $e');
    }
  }
}

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

class Exercise {
  final String id;
  final String type;           // e.g., "Run"
  final Intensity intensity;   // e.g., Intensity.low
  final int durationMins;      // e.g., 30
  final int caloriesBurned;    // e.g., 221 (nullable if not calculated yet)
  final DateTime? timestamp;    // When it happened

  Exercise({
    required this.id,
    required this.type,
    required this.intensity,
    required this.durationMins,
    required this.caloriesBurned,
    required this.timestamp,
  });

  // Factory constructor to create an instance from JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String? ?? '',
      type: json['exerciseType'] ?? "",
      intensity: Intensity.fromString(json['intensity'] as String),
      durationMins: (json['durationMins'] as num).toInt(),
      caloriesBurned: (json['caloriesBurned'] as num).toInt(),
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(json['timestamp']?.toString() ?? ''),
    );
  }

  // Convert instance to JSON (for API requests or local storage)
  Map<String, dynamic> toJson({double? weightKg}) {
    final data = {
      'exercise_type': type,
      'intensity': intensity.label, // Sends "Low", "Medium", etc.
      'duration_mins': durationMins,
      'timestamp': timestamp?.toIso8601String(),
    };

    // If sending to the /log_exercise endpoint, we need to inject weight
    if (weightKg != null) {
      data['weight_kg'] = weightKg;
    }

    return data;
  }

  // UI Helper: Returns "9:42 AM"
  String get formattedTime {
    if (timestamp == null) return '--:--'; // Or "Pending"
    return DateFormat.jm().format(timestamp!);
  }
}