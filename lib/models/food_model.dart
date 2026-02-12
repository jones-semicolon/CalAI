import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'nutrition_model.dart';

// 1. The Contract: Defines what "Nutrition" looks like
@immutable
abstract class FoodBase extends Nutrition {
  final String name;
  final List portions;
  final List<Food> ingredients;
  final List<OtherNutrient> otherNutrients; // Renamed for consistency

  const FoodBase({
    required this.name,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fats,
    required super.fiber,
    required super.sugar,
    required super.sodium,
    required super.water,
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
  final double? healthScore;

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
    super.ingredients,
    this.imageUrl,
    this.healthScore,
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
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0,
      water: (json['water'] as num?)?.toDouble() ?? 0,
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

  FoodLog copyWith({
    String? id,
    String? foodId,
    double? amount,
    String? portion,
    DateTime? timestamp,
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? fiber,
    double? sugar,
    double? sodium,
    double? water,
    String? imageUrl,
    double? healthScore,
    List<OtherNutrient>? otherNutrients,
  }) {
    return FoodLog(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      amount: amount ?? this.amount,
      portion: portion ?? this.portion,
      timestamp: timestamp ?? this.timestamp,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      water: water ?? this.water,
      imageUrl: imageUrl ?? this.imageUrl,
      healthScore: healthScore ?? this.healthScore,
      otherNutrients: otherNutrients ?? this.otherNutrients,
    );
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
  final int? healthScore;

  const Food({
    required this.id,
    required this.source,
    this.parentFoodId,
    this.ownerId,
    this.imageUrl,
    this.healthScore,
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
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0,
      water: (json['water'] as num?)?.toDouble() ?? 0,
      timestamp: Timestamp.fromDate(DateTime.parse(json['timestamp'])),
    );
  }

  factory Food.fromFoodFact(Map<String, dynamic> json) {
    final nutrients = json['nutrients'] ?? {};

    // Helper to safely handle Null, int, and double
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return 0.0;
    }

    return Food(
      id: json['barcode']?.toString() ?? '',
      source: 'foodfacts',
      timestamp: Timestamp.now(),
      name: json['name']?.toString() ?? 'Unknown Food',
      // ✅ Using the helper for all numeric fields
      calories: toDouble(nutrients['calories']).toDouble(),
      protein: toDouble(nutrients['protein']).toDouble(),
      carbs: toDouble(nutrients['carbs']).toDouble(),
      fats: toDouble(nutrients['fats']).toDouble(),
      fiber: toDouble(nutrients['fibers']).toDouble(),
      sugar: toDouble(nutrients['sugar']).toDouble(),
      sodium: toDouble(nutrients['sodium']).toDouble(),
      water: toDouble(nutrients['water']).toDouble(),
      imageUrl: json['image_url']?.toString(),
      healthScore: json['health_score'] as int?,
      portions: [
        FoodPortionItem(
          label: json['serving_size']?.toString() ?? "Serving",
          gramWeight: toDouble(json['servings_per_container']) > 0
              ? toDouble(json['servings_per_container'])
              : 100.0, // Fallback to 100g if missing
        )
      ],
      // ingredients: json['ingredients'] ?? {},
    );
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    // The backend now provides a flattened nutrients map
    final nutrients = json['nutrients'] ?? {};

    // Helper to safely convert any numeric type (int/double) to a double
    double getValue(dynamic entry) {
      if (entry == null) return 0.0;

      // If it's a Map (like FDC data), look for 'amount'
      if (entry is Map && entry.containsKey('amount')) {
        final amt = entry['amount'];
        return amt is num ? amt.toDouble() : 0.0;
      }

      // If it's already a number (like your Node.js scan/barcode data)
      if (entry is num) {
        return entry.toDouble();
      }

      return 0.0;
    }

    return Food(
      // Handle Firestore 'id', barcode from Node.js, or USDA 'fdcId'
      id: json['id']?.toString() ?? json['barcode']?.toString() ?? json['fdcId']?.toString() ?? '',

      source: json['source']?.toString() ?? 'unknown',
      parentFoodId: json['parentFoodId']?.toString() ?? '',
      ownerId: json['ownerId']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['imageUrl']?.toString(),
      name: json['name']?.toString() ?? 'Unknown Food',

      calories: getValue(nutrients['calories']).toDouble(),
      protein: getValue(nutrients['proteins'] ?? nutrients['protein']).toDouble(),
      carbs: getValue(nutrients['carbs'] ?? nutrients['carbohydrates']).toDouble(),
      fats: getValue(nutrients['fats'] ?? nutrients['fat']).toDouble(),
      fiber: getValue(nutrients['fibers'] ?? nutrients['fiber']).toDouble(),
      sugar: getValue(nutrients['sugar'] ?? nutrients['sugars']).toDouble(),
      sodium: getValue(nutrients['sodium']).toDouble(),
      water: getValue(nutrients['water']).toDouble(),

      otherNutrients: json['other_nutrients'] != null
          ? (json['other_nutrients'] as List).map((e) => OtherNutrient.fromJson(e)).toList()
          : [],

      portions: json['portions'] != null
          ? (json['portions'] as List).map((e) => FoodPortionItem.fromJson(e)).toList()
          : [],

      healthScore: json['health_score'] as int?,

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
    double scale(num val) => (val * totalMultiplier);

    return FoodLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodId: id,
      amount: amount,
      portion: unit,
      timestamp: DateTime.now(),
      name: name,
      imageUrl: imageUrl,
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

  OtherNutrient copyWith({
    String? name,
    double? amount,
    String? unit,
  }) {
    return OtherNutrient(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
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