import 'dart:convert';
import 'package:calai/data/global_data.dart';
import 'package:calai/models/food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FoodApi {
  static const _host = "cal-ai-liard.vercel.app";
  // static const _protocol = "http";
  // static const _domain = "10.0.2.2";
  // static const _port = 3000;

// Use this to build your URI
//   static const _host = "$_protocol://$_domain:$_port";
  /// ✅ GET /food?id=1,2,3
  static Future<List<Food>> getFoodsByIds(List<String> ids) async {
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
          .map(Food.fromJson)
          .toList();
    }

    // ✅ If API returns a single object (fallback)
    if (decoded is Map<String, dynamic>) {
      return [Food.fromJson(decoded)];
    }

    throw Exception("Unexpected response format");
  }

  static Future<List<Food>> search(String query) async {
    final uri = Uri.https(_host, "/food/search", {"q": query});

    final res = await http.get(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Food search failed (${res.statusCode})");
    }

    final decoded = jsonDecode(res.body)['foods'];
    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Food.fromJson)
          .toList();
    }
    // ✅ If API returns a single object (fallback)
    if (decoded is Map<String, dynamic>) {
      return [Food.fromJson(decoded)];
    }

    throw Exception("Unexpected response format");
    }
}