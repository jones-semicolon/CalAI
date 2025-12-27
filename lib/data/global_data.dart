import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GlobalData extends ChangeNotifier {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() => _instance;

  GlobalData._internal();

  // Default values
  int calorieGoal = 0;
  int proteinGoal = 0;
  int carbsGoal = 0;
  int fatsGoal = 0;
  int fiberGoal = 0;
  int sugarGoal = 0;
  int sodiumGoal = 0;

  /// Fetch goals from API
  Future<void> fetchGoals() async {
    try {
      final response = await http.get(
        Uri.parse('https://cal-ai-liard.vercel.app/test/goals'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = json['data'];
        final nutrients = data['nutrients'];
        final micro = nutrients['micronutrients'];

        calorieGoal = data['calories'] ?? calorieGoal;
        proteinGoal = nutrients['protein_g'] ?? proteinGoal;
        carbsGoal = nutrients['carbs_g'] ?? carbsGoal;
        fatsGoal = nutrients['fat_g'] ?? fatsGoal;
        sugarGoal = micro['sugar_g'] ?? sugarGoal;
        sodiumGoal = micro['sodium_mg'] ?? sodiumGoal;
        fiberGoal = micro['fiber_g'] ?? fiberGoal;

        notifyListeners();
      } else {
        debugPrint('Failed to fetch goals: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching goals: $e');
    }
  }
}
