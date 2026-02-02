import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// ----------------------------
/// MODEL
/// ----------------------------

class Goals {
  final int calories;
  final Nutrients nutrients;

  Goals({required this.calories, required this.nutrients});

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      calories: json['calories'],
      nutrients: Nutrients.fromJson(json['nutrients']),
    );
  }
}

class Nutrients {
  final int protein;
  final int carbs;
  final int fat;
  final Micronutrients micronutrients;

  Nutrients({
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.micronutrients,
  });

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
      protein: json['protein_g'],
      carbs: json['carbs_g'],
      fat: json['fat_g'],
      micronutrients: Micronutrients.fromJson(json['micronutrients']),
    );
  }
}

class Micronutrients {
  final int sugar;
  final int sodium;
  final int fiber;

  Micronutrients({
    required this.sugar,
    required this.sodium,
    required this.fiber,
  });

  factory Micronutrients.fromJson(Map<String, dynamic> json) {
    return Micronutrients(
      sugar: json['sugar_g'],
      sodium: json['sodium_mg'],
      fiber: json['fiber_g'],
    );
  }
}

final goalsProvider = AsyncNotifierProvider<GoalsNotifier, Goals>(
  GoalsNotifier.new,
);

class GoalsNotifier extends AsyncNotifier<Goals> {
  static const _endpoint = 'https://cal-ai-liard.vercel.app/test/goals';

  @override
  Future<Goals> build() async {
    return _fetchGoals();
  }

  Future<Goals> _fetchGoals() async {
    final response = await http.get(Uri.parse(_endpoint));

    // await Future.delayed(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch goals');
    }

    final decoded = json.decode(response.body);

    return Goals.fromJson(decoded['data']);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchGoals);
  }
}
