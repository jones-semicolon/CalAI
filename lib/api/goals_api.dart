import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class GoalsApi {
  static const String _baseUrl = "cal-ai-liard.vercel.app";
  static const String _endpoint = "/calculate-goals";

  /// Calculates nutritional goals based on user profile
  Future<Map<String, dynamic>?> calculateGoals(User user) async {
    try {
      final uri = Uri.https(
        _baseUrl,
        _endpoint,
        {
          "age": _calculateAge(user.profile.birthDate ?? DateTime.now()).toString(),
          "gender": user.profile.gender?.value ?? "other",
          "height": user.body.height.toString(),
          "weight": user.body.currentWeight.toString(),
          "activity_level": user.goal.activityLevel?.value ?? "low",
          "goal": user.goal.type?.value ?? "maintain",
        },
      );

      final response = await http.get(uri);
      debugPrint('GoalsApi Response: ${response.body}');
      if (response.statusCode < 200 || response.statusCode >= 300) return null;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final apiData = body['data'] as Map<String, dynamic>?;
      if (apiData == null) return null;

      final nutrients = apiData['nutrients'] as Map<String, dynamic>?;
      final micro = nutrients?['micronutrients'] as Map<String, dynamic>?;

      return {
        'calorieGoal': (apiData['calories'] ?? 0).toInt(),
        'proteinGoal': (nutrients?['protein_g'] ?? 0).toInt(),
        'carbsGoal': (nutrients?['carbs_g'] ?? 0).toInt(),
        'fatsGoal': (nutrients?['fat_g'] ?? 0).toInt(),
        'fiberGoal': (micro?['fiber_g'] ?? 0).toInt(),
        'sugarGoal': (micro?['sugar_g'] ?? 0).toInt(),
        'sodiumGoal': (micro?['sodium_mg'] ?? 0).toInt(),
      };
    } catch (e) {
      debugPrint('GoalsApi Error: $e');
      return null;
    }
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    final birthdayThisYear = DateTime(today.year, birthDate.month, birthDate.day);
    if (today.isBefore(birthdayThisYear)) age--;
    return age;
  }
}