// 1. The Contract: Defines what "Nutrition" looks like
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class FoodBase {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final int fiber;
  final int sugar;
  final int sodium;
  final int water;
  final List portions;
  final List<Food> ingredients;
  final List<OtherNutrient> otherNutrients; // Renamed for consistency

  const FoodBase({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.water,
    this.portions = const [],
    this.ingredients = const [],
    this.otherNutrients = const [],
  });
}

// 3. The Diary Entry: A specific instance of eating (e.g. "Banana - 2.5 pcs")
class FoodLog extends FoodBase {
  final String id;
  final String foodId;
  final double amount;
  final String portion;
  final DateTime timestamp;
  final String? imageUrl;

  const FoodLog({
    required this.id,
    required this.foodId,
    required this.amount,
    required this.portion,
    required this.timestamp,
    required super.name,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fats,
    required super.fiber,
    required super.sugar,
    required super.sodium,
    required super.water,
    this.imageUrl,
    super.otherNutrients,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodId': foodId,
      'amount': amount,
      'portion': portion,
      // Note: When saving to Firestore, using .toIso8601String() is fine,
      // but Firestore prefers FieldValue.serverTimestamp() or raw DateTime objects.
      'timestamp': timestamp.toIso8601String(),
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'water': water,
      'imageUrl': imageUrl,
      // Don't forget to save nutrients if you want them in history!
      'otherNutrients': otherNutrients.map((e) => e.toJson()).toList(),
    };
  }

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id']?.toString() ?? '',
      foodId: json['foodId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      portion: json['portion']?.toString() ?? '',

      // ✅ FIX: Use the helper to handle Timestamp vs String
      timestamp: _parseTimestamp(json['timestamp']),

      name: json['name']?.toString() ?? 'Unknown Food',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fats: (json['fats'] as num?)?.toInt() ?? 0,
      fiber: (json['fiber'] as num?)?.toInt() ?? 0,
      sugar: (json['sugar'] as num?)?.toInt() ?? 0,
      sodium: (json['sodium'] as num?)?.toInt() ?? 0,
      water: (json['water'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl']?.toString(),

      // ✅ FIX: Restore otherNutrients parsing
      otherNutrients: json['otherNutrients'] != null
          ? (json['otherNutrients'] as List)
          .map((e) => OtherNutrient.fromJson(e))
          .toList()
          : [],
    );
  }

  // ✅ HELPER: Safely parses dates from Firestore or JSON
  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate(); // Firestore format
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now(); // JSON format
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now(); // Fallback
  }
}

// 2. The Database Reference: A food template (e.g. "Banana - 100g")
class Food extends FoodBase {
  final String id;
  final String source;
  final String? imageUrl;
  final String? parentFoodId;
  final String? ownerId;
  final Timestamp timestamp;

  const Food({
    required this.id,
    required this.source,
    this.parentFoodId,
    this.ownerId,
    this.imageUrl,
    required this.timestamp,
    required super.name,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fats,
    required super.fiber,
    required super.sugar,
    required super.sodium,
    required super.water,
    super.portions,
    super.ingredients,
    super.otherNutrients,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'imageUrl': imageUrl,
      'parentFoodId': parentFoodId,
      'ownerId': ownerId,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'water': water,
      'timestamp': timestamp.toDate().toIso8601String(),
    };
  }

  static Food fromDoc(Map<String, dynamic> json) {
    return Food(
      id: json['id'].toString(),
      source: json['source']?.toString() ?? 'unknown',
      parentFoodId: json['parentFoodId']?.toString() ?? '',
      ownerId: json['ownerId']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      name: json['name']?.toString() ?? 'Unknown Food',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fats: (json['fats'] as num?)?.toInt() ?? 0,
      fiber: (json['fiber'] as num?)?.toInt() ?? 0,
      sugar: (json['sugar'] as num?)?.toInt() ?? 0,
      sodium: (json['sodium'] as num?)?.toInt() ?? 0,
      water: (json['water'] as num?)?.toInt() ?? 0,
      timestamp: Timestamp.fromDate(DateTime.parse(json['timestamp'])),
    );
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    final nutrients = json['nutrients'];

    return Food(
      // 1. Handle ID: Check 'id' (Firestore) OR 'fdcId' (USDA API)
      id: json['id']?.toString() ?? json['fdcId']?.toString() ?? '',

      source: json['source']?.toString() ?? 'unknown',
      parentFoodId: json['parentFoodId']?.toString() ?? '',
      ownerId: json['ownerId']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      name: json['name']?.toString() ?? 'Unknown Food',

      // Nutrients with safety checks
      calories: (nutrients['calories']?['amount'] as num?)?.toInt() ?? 0,
      protein: (nutrients['proteins']?['amount'] as num?)?.toInt() ?? 0,
      carbs: (nutrients['carbs']?['amount'] as num?)?.toInt() ?? 0,
      fats: (nutrients['fats']?['amount'] as num?)?.toInt() ?? 0,
      fiber: (nutrients['fiber']?['amount'] as num?)?.toInt() ?? 0,
      sugar: (nutrients['sugar']?['amount'] as num?)?.toInt() ?? 0,
      sodium: (nutrients['sodium']?['amount'] as num?)?.toInt() ?? 0,
      water: (nutrients['water']?['amount'] as num?)?.toInt() ?? 0,

      otherNutrients: json['other_nutrients'] != null
          ? (json['other_nutrients'] as List).map((e) => OtherNutrient.fromJson(e)).toList()
          : [],

      // 2. Handle Portions: Your API returns 'portions', make sure to parse it!
      portions: json['portions'] != null
          ? (json['portions'] as List).map((e) => FoodPortionItem.fromJson(e)).toList()
          : [],

      // 3. Fix Timestamp: If missing, default to Now
      timestamp: json['timestamp'] != null
          ? Timestamp.fromDate(DateTime.parse(json['timestamp']))
          : Timestamp.now(),
    );
  }

  FoodLog createLog({
    double weight = 100, // The reference weight (usually 100g)
    required double amount, // The number of units (e.g., 2)
    required String unit, // The unit label (e.g., "Large Egg")
    required double gramWeight // The weight of a single unit (e.g., 50g)
  }) {
    // Total grams = amount * gramWeight.
    // Multiplier = totalGrams / referenceWeight.
    final double totalMultiplier = (amount * gramWeight) / weight;

    // Helper to scale and round
    int scale(num val) => (val * totalMultiplier).round();

    return FoodLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodId: id,
      amount: amount,
      portion: "$amount x $unit",
      timestamp: DateTime.now(),
      name: name,
      calories: scale(calories),
      protein: scale(protein),
      carbs: scale(carbs),
      fats: scale(fats),
      fiber: scale(fiber),
      sugar: scale(sugar),
      sodium: scale(sodium),
      water: scale(water),
      otherNutrients: otherNutrients.map((n) {
        return OtherNutrient(
          name: n.name,
          unit: n.unit,
          amount: scale(n.amount).toDouble(),
        );
      }).toList(),
    );
  }
}

// 4. The Micro-Nutrients
class OtherNutrient {
  final String name;
  final double amount; // Changed to double for precision (e.g. 2.5mg Iron)
  final String unit;   // e.g. "mg", "g", "IU"

  const OtherNutrient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
    };
  }

  factory OtherNutrient.fromJson(Map<String, dynamic> json) {
    return OtherNutrient(
      name: (json['name'] ?? '').toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      unit: (json['unitName'] ?? json['unit'] ?? '').toString(),
    );
  }
}

class FoodPortionItem {
  final String label;      // The server now sends "Tbsp" or "Slice" cleanly
  final double gramWeight; // e.g., 16.0

  const FoodPortionItem({
    required this.label,
    required this.gramWeight
  });

  Map<String, dynamic> toJson() {
    return {
      "label": label,
      "gramWeight": gramWeight
    };
  }

  factory FoodPortionItem.fromJson(Map<String, dynamic> json) {
    return FoodPortionItem(
      // ✅ FIX: Use 'label', not 'portionDescription'
      // The server guarantees this is clean now.
      label: json['label']?.toString() ?? 'Serving',

      gramWeight: (json['gramWeight'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // ✅ Getter: Since the server already cleaned the string (removed numbers, etc.),
  // 'label' IS the unit. We don't need regex logic here anymore.
  String get unitOnly => label;

// You can verify this works with your JSON:
// Input: {"label": "Tbsp", "gramWeight": 16}
// Result: label="Tbsp", gramWeight=16.0
}