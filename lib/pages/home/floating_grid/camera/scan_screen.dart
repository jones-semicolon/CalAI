import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For a clean iOS-style loader
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/l10n/l10n.dart';

import '../../../../api/food_api.dart';
import '../../../../enums/food_enums.dart';
import '../../../../models/food_model.dart';
import '../../../../services/calai_firestore_service.dart';
import 'camera_scanner/camera_scanner_widget.dart';
import 'camera_scanner/scan_mode.dart';

class ScanScreen extends ConsumerStatefulWidget {
  final ScanMode initialMode;

  const ScanScreen({
    super.key,
    this.initialMode = ScanMode.scanFood,
  });

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _isLoading = false;
  bool _isSuccess = false; // ✅ Track success for UI feedback

  Future<void> _handleBarcode(String barcode) async {
    if (_isLoading || _isSuccess) return;
    setState(() => _isLoading = true);

    try {
      final food = await FoodApi.postBarcode(barcode);

      if (!mounted) return;

      // Calculate initial log (defaulting to 1 serving/100g)
      final initialLog = food.createLog(
        amount: 1.0,
        unit: food.portions.isNotEmpty ? food.portions.first.label : context.l10n.servingLabel,
        gramWeight: food.portions.isNotEmpty ? food.portions.first.gramWeight : 100.0,
      );

      // ✅ Save to Firestore immediately
      await ref.read(calaiServiceProvider).logFoodEntry(
        initialLog,
        SourceType.foodFacts,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        // Brief delay so user sees the "Success" state
        await Future.delayed(const Duration(milliseconds: 1000));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.productNotFoundMessage)),
        );
      }
    }
  }

  // Inside ScanScreen
  Future<void> _handleVisionScan(String imagePath) async {
    setState(() => _isLoading = true);
    try {
      // Send the path instead of a large base64 string
      final food = await FoodApi.scanFood(imagePath);

      final initialLog = food.createLog(
        amount: 1.0,
        unit: context.l10n.servingLabel,
        gramWeight: 100.0,
      );
      debugPrint("Initial Log: ${initialLog.toJson().toString()}");

      await ref.read(calaiServiceProvider).logFoodEntry(
        initialLog,
        SourceType.vision,
      );

      if (mounted) setState(() => _isSuccess = true);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Vision Scan Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLabelScan(String text) async {
    // debugPrint("query: $text");
    // Navigator.pop(context);
    if (_isLoading || _isSuccess || text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      // 1. Search for the food using the captured label text
      final List<Food> results = await FoodApi.search(text);

      if (results.isEmpty) {
        throw Exception(context.l10n.foodNotFoundMessage);
      }

      // 2. Grab the first (most relevant) item
      final bestMatch = results.first;

      final portion = _getDisplayPortion(context, bestMatch);

      debugPrint("Best Match: ${bestMatch.toJson().toString()}");

      // 3. Create the log entry
      final initialLog = bestMatch.createLog(
        amount: 1,
        unit: portion.label,
        gramWeight: portion.gramWeight
      );

      // 4. Save to Firestore
      await ref.read(calaiServiceProvider).logFoodEntry(
        initialLog,
        SourceType.foodDatabase, // Or create a SourceType.ocr if you prefer
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
          SnackBar(content: Text(context.l10n.couldNotIdentify(text))),
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
            initialMode: widget.initialMode,
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
                      _isLoading
                          ? context.l10n.identifyingFoodMessage
                          : context.l10n.loggedSuccessfullyMessage,
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

FoodPortionItem _getDisplayPortion(BuildContext context, Food item) {
  // ✅ FIX: Don't call .fromJson() here.
  // The model already parsed it. Just cast the list to the correct type.
  final List<FoodPortionItem> portions = item.portions.cast<FoodPortionItem>();

  if (portions.isEmpty) {
    return FoodPortionItem(label: context.l10n.servingLabel, gramWeight: 100);
  }

  // Try to find a portion that isn't just "100g" or "Quantity not specified"
  return portions.firstWhere(
        (p) => !p.label.toLowerCase().contains("quantity not specified"),
    orElse: () => portions.first,
  );
}
