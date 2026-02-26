import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For a clean iOS-style loader
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/food_api.dart';
import '../../../../enums/food_enums.dart';
import '../../../../models/food_model.dart';
import '../../../../services/calai_firestore_service.dart';
import 'camera_scanner/camera_scanner_widget.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _isLoading = false;
  bool _isSuccess = false;

  Future<void> _handleBarcode(String barcode) async {
    if (_isLoading || _isSuccess) return;
    setState(() => _isLoading = true);

    try {
      final food = await FoodApi.postBarcode(barcode);

      if (!mounted) return;

      ref.read(calaiServiceProvider).saveFood(food.copyWith(source: SourceType.vision.value));

      final initialLog = food.createLog(
        amount: 1.0,
        unit: food.portions.isNotEmpty ? food.portions.first.label : "Serving",
        gramWeight: food.portions.isNotEmpty ? food.portions.first.gramWeight : 100.0,
      );

      await ref.read(calaiServiceProvider).logFoodEntry(
        initialLog,
        SourceType.foodFacts,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        await Future.delayed(const Duration(milliseconds: 1000));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found.')),
        );
      }
    }
  }

  Future<void> _handleVisionScan(String imagePath) async {
  setState(() => _isLoading = true);
  try {
    final food = await FoodApi.scanFood(imagePath);
    
    if (!mounted) return;
    final foodId = food.id.isEmpty 
        ? ref.read(calaiServiceProvider).savedFoodCol.doc().id 
        : food.id;
    
    final foodToSave = food.copyWith(
      id: foodId,
      source: SourceType.vision.value,
    );

    await ref.read(calaiServiceProvider).saveFood(foodToSave);

    final initialLog = foodToSave.createLog(
      amount: 1.0,
      unit: "Serving",
      gramWeight: 100.0,
    );

    await ref.read(calaiServiceProvider).logFoodEntry(
      initialLog,
      SourceType.vision,
    );

    if (mounted) setState(() => _isSuccess = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) Navigator.pop(context);
  } catch (e) {
    debugPrint("Vision Scan Error: $e");
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  Future<void> _handleLabelScan(String text) async {
    if (_isLoading || _isSuccess || text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final List<Food> results = await FoodApi.search(text);

      if (results.isEmpty) {
        throw Exception("No food found for this label.");
      }

      final bestMatch = results.first;

      final portion = _getDisplayPortion(bestMatch);

      debugPrint("Best Match: ${bestMatch.toJson().toString()}");

      ref.read(calaiServiceProvider).saveFood(bestMatch.copyWith(source: SourceType.vision.value));

      final initialLog = bestMatch.createLog(
        amount: 1,
        unit: portion.label,
        gramWeight: portion.gramWeight
      );

      await ref.read(calaiServiceProvider).logFoodEntry(
        initialLog,
        SourceType.foodDatabase,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });
        await Future.delayed(const Duration(milliseconds: 1000));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Label Scan Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not identify "$text".')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The Camera Scanner
          CameraScannerWidget(
            onImageCaptured: (image) => _handleVisionScan(image.path),
            onBarcodeCaptured: (barcode) => _handleBarcode(barcode),
            onFoodLabelCaptured: (text) => _handleLabelScan(text),
            onGalleryPicked: (image) => _handleVisionScan(image.path),
          ),

          // ✅ The Loading Indicator Overlay
          if (_isLoading || _isSuccess)
            Container(
              color: Colors.black54, // Dim the background
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CupertinoActivityIndicator(radius: 20, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      _isLoading ? 'Identifying food...' : 'Logged successfully!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

FoodPortionItem _getDisplayPortion(Food item) {
  // ✅ FIX: Don't call .fromJson() here.
  // The model already parsed it. Just cast the list to the correct type.
  final List<FoodPortionItem> portions = item.portions.cast<FoodPortionItem>();

  if (portions.isEmpty) {
    return const FoodPortionItem(label: "Serving", gramWeight: 100);
  }

  // Try to find a portion that isn't just "100g" or "Quantity not specified"
  return portions.firstWhere(
        (p) => !p.label.toLowerCase().contains("quantity not specified"),
    orElse: () => portions.first,
  );
}