import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GlobalData extends ChangeNotifier {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() => _instance;

  GlobalData._internal();

  // Default values
  int caloriesADay = 0;
  int proteinADay = 0;
  int carbsADay = 0;
  int fatsADay = 0;
  int fiberADay = 0;
  int sugarADay = 0;
  int sodiumADay = 0;

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

        caloriesADay = data['calories'] ?? caloriesADay;
        proteinADay = nutrients['protein_g'] ?? proteinADay;
        carbsADay = nutrients['carbs_g'] ?? carbsADay;
        fatsADay = nutrients['fat_g'] ?? fatsADay;
        sugarADay = micro['sugar_g'] ?? sugarADay;
        sodiumADay = micro['sodium_mg'] ?? sodiumADay;
        fiberADay = micro['fiber_g'] ?? fiberADay;

        notifyListeners();
      } else {
        debugPrint('Failed to fetch goals: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching goals: $e');
    }
  }
}
