import 'package:calai/models/nutrition_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SourceType {
  foodDatabase("foodDatabase"),
  foodUpload("foodUpload"),
  exercise("exercise"),
  foodFacts("foodFacts"),
  vision("vision");

  final String value;
  const SourceType(this.value);

  static SourceType fromString(String val) {
    return SourceType.values.firstWhere(
          (e) => e.value.toLowerCase() == val.toLowerCase().trim(),
      orElse: () => SourceType.foodDatabase,
    );
  }
}

enum NutritionType {
  protein,
  carbs,
  fats;

  IconData get icon {
    switch (this) {
      case NutritionType.protein:
        return Icons.egg_alt;
      case NutritionType.carbs:
        return Icons.rice_bowl;
      case NutritionType.fats:
        return Icons.fastfood;
    }
  }

  String get label {
    switch (this) {
      case NutritionType.protein:
        return "Protein";
      case NutritionType.carbs:
        return "Carbs";
      case NutritionType.fats:
        return "Fats";
    }
  }

  Color get color {
    switch (this) {
      case NutritionType.protein:
        return Color.fromARGB(255, 221, 105, 105);
      case NutritionType.carbs:
        return Color.fromARGB(255, 222, 154, 105);
      case NutritionType.fats:
        return Color.fromARGB(255, 105, 152, 222);
    }
  }

  static NutritionType fromString(String val) {
    return NutritionType.values.firstWhere(
      (e) => e.name == val,
      orElse: () => NutritionType.protein,
    );
  }
}

enum MicroNutritionType {
  sugar,
  fiber,
  sodium;

  IconData get icon {
    switch (this) {
      case MicroNutritionType.fiber:
        return Icons.grain;
      case MicroNutritionType.sugar:
        return Icons.icecream;
      case MicroNutritionType.sodium:
        return Icons.restaurant_menu;
    }
  }

  String get label {
    switch (this) {
      case MicroNutritionType.fiber:
        return "Fiber";
      case MicroNutritionType.sugar:
        return "Sugar";
      case MicroNutritionType.sodium:
        return "Sodium";
    }
  }

  Color get color {
    switch (this) {
      case MicroNutritionType.fiber:
        return Color.fromARGB(255, 163, 137, 211);
      case MicroNutritionType.sugar:
        return Color.fromARGB(255, 244, 143, 177);
      case MicroNutritionType.sodium:
        return Color.fromARGB(255, 231, 185, 110);
    }
  }

  static MicroNutritionType fromString(String val) {
    return MicroNutritionType.values.firstWhere(
      (e) => e.name == val,
      orElse: () => MicroNutritionType.fiber,
    );
  }
}
