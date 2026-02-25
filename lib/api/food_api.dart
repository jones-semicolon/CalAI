import 'dart:convert';
import 'package:calai/models/food_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class FoodApi {
  // static const _host = "cal-ai-liard.vercel.app";
  static const bool _isLocal = false;

  static const _domain = _isLocal ? "10.0.2.2" : "cal-ai-liard.vercel.app";
  static const _port = 3000;

    static const _host = "$_domain:$_port";
  static Future<List<Food>> getFoodsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final joined = ids.join(",");
    // final uri = Uri.https(_host, "/food", {"id": joined});

    final uri = _isLocal
        ? Uri.http("$_domain:$_port", "/food", {"id": ids})
        : Uri.https(_domain, "/food", {"id": ids});

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
    // final uri = Uri.https(_host, "/food/search", {"q": query});

    final uri = _isLocal
        ? Uri.http("$_domain:$_port", "/food/search", {"q": query})
        : Uri.https(_domain, "/food/search", {"q": query});
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

  static Future<Food> scanFood(String imagePath) async {
    final uri = _isLocal
        ? Uri.http("$_domain:$_port", "/scan-food")
        : Uri.https(_domain, "/scan-food");

    // Use MultipartRequest for better performance and lower data usage
    var request = http.MultipartRequest('POST', uri);

    // Attach the file directly from the path
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Scan failed: ${response.body}");
    }

    final decoded = jsonDecode(response.body)['data'];
    debugPrint("decoded: $decoded");
    return Food.fromJson(decoded);
  }

  static Future<Food> postBarcode(String barcode) async {
    // Explicitly using <String, String> to avoid the type casting error
    final uri = _isLocal
        ? Uri.http("$_domain:$_port", "/scan-barcode", {"barcode": barcode})
        : Uri.https(_domain, "/scan-barcode", {"barcode": barcode});

    debugPrint("Fetching: ${uri.toString()}");
    debugPrint("Fetching food for barcode: $barcode");

    try {
      final res = await http.get(uri);

      if (res.statusCode == 404) {
        throw Exception("Product not found");
      }

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception("Server error: ${res.statusCode}");
      }

      final body = jsonDecode(res.body);
      debugPrint(body.toString());

      // Validation based on your specific JSON structure
      if (body['success'] != true || body['data'] == null) {
        throw Exception("No nutrition data available for this item.");
      }

      return Food.fromFoodFact(body['data']);
    } catch (e) {
      debugPrint("API Error: $e");
      rethrow;
    }
  }
}
