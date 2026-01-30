import 'dart:convert';
import 'package:calai/data/global_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FoodApi {
  static const _host = "cal-ai-liard.vercel.app";

  /// ✅ GET /food?id=1,2,3
  static Future<List<FoodSearchItem>> getFoodsByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    final joined = ids.join(",");
    final uri = Uri.https(_host, "/food", {"id": joined});

    final res = await http.get(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Food details failed (${res.statusCode})");
    }

    final decoded = jsonDecode(res.body);

    // ✅ If API returns a List<dynamic>
    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(FoodSearchItem.fromJson)
          .toList();
    }

    // ✅ If API returns a single object (fallback)
    if (decoded is Map<String, dynamic>) {
      return [FoodSearchItem.fromJson(decoded)];
    }

    throw Exception("Unexpected response format");
  }
}

class FoodSearchItem {
  final int fdcId;
  final String name;
  final Map<String, dynamic>? nutrients;
  final double baseGramWeight;
  final int calories;
  final String? imageUrl;
  final List<OtherNutrient> otherNutrients;
  final DateTime? timestamp;

  /// ✅ calories per 100g (or base reference)
  final double caloriesPer100g;

  final List<FoodPortionItem> portions;

  const FoodSearchItem({
    required this.fdcId,
    required this.name,
    required this.caloriesPer100g,
    required this.calories,
    required this.portions,
    required this.otherNutrients,
    this.timestamp,
    this.imageUrl,
    this.nutrients,
    this.baseGramWeight = 100,
  });

  double get proteinG =>
      (nutrients?['protein_g']?['amount'] as num?)?.toDouble() ?? 0;
  double get carbsG =>
      (nutrients?['carbs_g']?['amount'] as num?)?.toDouble() ?? 0;
  double get fatG => (nutrients?['fat_g']?['amount'] as num?)?.toDouble() ?? 0;

  double caloriesForGrams(double grams) {
    final base = baseGramWeight;
    if (base <= 0) return caloriesPer100g;
    return caloriesPer100g * (grams / base);
  }

  /// ✅ Default portion shown in UI
  FoodPortionItem get defaultPortion {
    if (portions.isEmpty) {
      return const FoodPortionItem(label: "gram", gramWeight: 100);
    }

    // ✅ prefer common portions like "1 cup", "1 tbsp", "1 serving"
    final preferred = portions.firstWhere((p) {
      final l = p.label.toLowerCase();
      return l.contains("cup") ||
          l.contains("tbsp") ||
          l.contains("tablespoon") ||
          l.contains("serving") ||
          l.contains("large");
    }, orElse: () => FoodPortionItem(label: "gram", gramWeight: 100));

    return preferred;
  }

  /// ✅ calories for the given portion
  double nutrientsForPortion(FoodPortionItem portion, double nutrients) {
    final grams = portion.gramWeight;
    if (grams <= 0) return caloriesPer100g;

    final cals = nutrients * (grams / 100.0);
    return cals;
  }

  // Inside your FoodSearchItem class
  Food toFood({
    int? convertedCalories,
    int? convertedProteins,
    int? convertedCarbs,
    int? convertedFats,
    String? portion,
  }) {
    return Food(
      id: fdcId.toString(),
      fdcId: fdcId.toString(),
      name: name,
      calories: convertedCalories ?? calories,
      protein: convertedProteins ?? proteinG.round(),
      carbs: convertedCarbs ?? carbsG.round(),
      fats: convertedFats ?? fatG.round(),
      servings: 1,
      portion: portion ?? "100g", // Default reference portion
      otherNutrients: otherNutrients, // Assuming types match
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fdcId": fdcId,
      "name": name,
      "calories": caloriesPer100g,
      "portions": portions.map((p) => p.toJson()).toList(),
      "nutrients": nutrients,
    };
  }

  String get formattedTime {
    return DateFormat.jm().format(timestamp!);
  }

  factory FoodSearchItem.fromJson(Map<String, dynamic> json) {
    final portionsRaw = (json['foodPortions'] as List?) ?? [];
    final otherRaw = (json['other'] as List?) ?? [];

    final portions = portionsRaw
        .whereType<Map<String, dynamic>>()
        .map(FoodPortionItem.fromJson)
        .where((p) => p.label.isNotEmpty)
        .toList();

    final otherNutrients = otherRaw
        .whereType<Map<String, dynamic>>()
        .map(OtherNutrient.fromJson)
        .where((n) => n.name.isNotEmpty)
        .toList();

    final nutrients = json['nutrients'];

    // ✅ remove duplicates
    final unique = <String, FoodPortionItem>{};
    for (final p in portions) {
      unique[p.label] = p;
    }

    return FoodSearchItem(
      fdcId: (json['fdcId'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? 'Unknown food').toString(),

      /// ✅ calories base (assume per 100g)
      caloriesPer100g:
          ((json['calories_kcal'] as Map<String, dynamic>?)?['amount'] as num?)
              ?.toDouble() ??
          0,
      calories:
          ((json['calories_kcal'] as Map<String, dynamic>?)?['amount'] as num?)
              ?.toInt() ??
          0,

      portions: unique.values.toList(),
      nutrients: nutrients,
      otherNutrients: otherNutrients,
    );
  }
}

class OtherNutrient {
  final String name;
  final double amount;
  final String unit;

  const OtherNutrient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'amount': amount, 'unit': unit};
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
  final String label; // ex: "1 cup", "1 tbsp", "100g"
  final double gramWeight;

  const FoodPortionItem({required this.label, required this.gramWeight});

  Map<String, dynamic> toJson() {
    return {"label": label, "gramWeight": gramWeight};
  }

  factory FoodPortionItem.fromJson(Map<String, dynamic> json) {
    final desc = (json['portionDescription'] ?? '').toString().trim();
    final grams = (json['gramWeight'] as num?)?.toDouble() ?? 0;

    // ✅ Best display label rules:
    // 1 cup / 1 tablespoon / Quantity not specified
    // if desc exists, use it, with modifier if useful

    String label = desc;

    // If it still looks bad, fallback to grams
    if (label.isEmpty) {
      label = grams > 0 ? "${grams.toStringAsFixed(0)} g" : "Serving";
    }

    return FoodPortionItem(label: label, gramWeight: grams);
  }

  String get unitOnly => _unitOnly(label);

  static String _unitOnly(String raw) {
    var t = raw.toLowerCase().trim();

    // 1. Handle the fallback case
    if (t.isEmpty || t.contains("quantity not specified")) return "per100";

    // 2. Remove leading numbers (1, 1.5, 1/2, 1 x)
    t = t.replaceFirst(RegExp(r'^(\d+\s*[\/\.]?\d*\s*(x\s*)?)'), '').trim();

    // 3. Keep specific shorthand for common small units if you like
    if (t.startsWith("tablespoon")) t = t.replaceFirst("tablespoon", "Tbsp");
    if (t.startsWith("teaspoon")) t = t.replaceFirst("teaspoon", "Tsp");
    if (t.startsWith("grams")) t = t.replaceFirst("grams", "G");

    // 4. Return the string with ONLY the first letter capitalized
    if (t.isEmpty) return "Serving";

    // This preserves "Cup, mashed or pureed" instead of just "Cup"
    return t[0].toUpperCase() + t.substring(1);
  }
}

class Food {
  final String id;
  final String? fdcId;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final String? imageUrl;
  final DateTime? timestamp;
  final List<OtherNutrient>? otherNutrients;
  final int servings;
  final String? portion;
  final FoodSource? source;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.imageUrl,
    this.timestamp,
    this.otherNutrients,
    this.servings = 1,
    this.portion,
    this.fdcId,
    this.source,
  });

  factory Food.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    debugPrint("RAW DATA: $data");

    // 1. Safe parsing helper for numbers
    int _asInt(dynamic value) {
      if (value is num) return value.round();
      return 0;
    }

    // 2. Identify if there is a nested 'macros' map (as seen in image 2)
    final Map<String, dynamic>? macros =
        data['macros'] as Map<String, dynamic>?;

    return Food(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      calories: _asInt(data['calories']),
      protein: _asInt(data['protein']),
      carbs: _asInt(data['carbs'] ?? macros?['c']),
      fats: _asInt(data['fats'] ?? macros?['f']),
      servings: _asInt(data['servings'] ?? data['serving'] ?? 1),
      portion: data['portion']?.toString() ?? '',
      imageUrl: data['imageUrl'],
      fdcId: data['fdcId']?.toString() ?? data['id']?.toString(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),

      otherNutrients: (data['otherNutrients'] as List<dynamic>?)
          ?.map((n) => OtherNutrient.fromJson(n as Map<String, dynamic>))
          .toList(),
      source: data['source'] ?? '',
    );
  }

  factory Food.fromMap(Map<String, dynamic> data, {String? id}) {
    int _asInt(dynamic v) => (v is num) ? v.round() : 0;

    return Food(
      id: id ?? data['id']?.toString() ?? '',
      name: data['name'] ?? 'Food',
      calories: _asInt(data['calories']),
      protein: _asInt(data['protein']),
      carbs: _asInt(data['carbs']),
      fats: _asInt(data['fats']),
      imageUrl: data['imageUrl'],
      portion: data['portion']?.toString(),
      servings: _asInt(data['servings'] ?? 1),
      fdcId: data['fdcId']?.toString(),
      timestamp: data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(data['timestamp']?.toString() ?? ''),
      otherNutrients: (data['otherNutrients'] as List?)
          ?.map((e) => OtherNutrient.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      source: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fdcId': fdcId,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'servings': servings,
      'portion': portion,
      'imageUrl': imageUrl,
      // Convert DateTime to ISO8601 string or use FieldValue.serverTimestamp() when saving to Firestore
      'timestamp': timestamp?.toIso8601String(),
      // Ensure OtherNutrient also has a toJson() method
      'otherNutrients': otherNutrients?.map((n) => n.toJson()).toList(),
      'source': source?.value,
    };
  }

  String get formattedTime => DateFormat.jm().format(timestamp!);
}
