import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../enums/exercise_enums.dart';
import '../models/exercise_model.dart';
// Import your model file here
// import 'package:calai/models/exercise_model.dart';

class ExerciseApi {
  static const _host = "cal-ai-liard.vercel.app";

  // ✅ Updated return type to List<ExerciseLog>
  Future<ExerciseLog> getBurnedCalories({
    required double weightKg,
    ExerciseType exerciseType = ExerciseType.run,
    Intensity intensity = Intensity.high,
    int durationMins = 0,
    String description = "",
  }) async {
    final uri = Uri.https(_host, '/log-exercise');

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: durationMins == 0
          ? jsonEncode({'weight_kg': weightKg, 'description': description})
          : jsonEncode({
        'weight_kg': weightKg,
        'exercise_type': exerciseType.name,
        'intensity': intensity.name,
        'duration_mins': durationMins,
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Exercise logging failed (${res.statusCode}): ${res.body}");
    }

    final decoded = jsonDecode(res.body)['data'];

    // ✅ If API returns a single object
    if (decoded is Map<String, dynamic>) {
      return ExerciseLog.fromJson(decoded);
    }

    throw Exception("Unexpected response format");
  }
}