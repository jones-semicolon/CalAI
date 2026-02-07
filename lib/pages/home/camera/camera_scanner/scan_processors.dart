import 'package:flutter/foundation.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ScanProcessors {
  bool _processingBarcode = false;
  bool _processingText = false;

  Future<String?> scanBarcode(XFile image) async {
    if (_processingBarcode) return null;
    _processingBarcode = true;

    final scanner = BarcodeScanner();
    try {
      final input = InputImage.fromFilePath(image.path);
      final barcodes = await scanner.processImage(input);
      return barcodes.isNotEmpty
          ? barcodes.first.rawValue ?? barcodes.first.displayValue
          : null;
    } catch (e) {
      debugPrint('Barcode scan failed: $e');
      return null;
    } finally {
      _processingBarcode = false;
      await scanner.close();
    }
  }

  Future<String?> scanText(XFile image) async {
    if (_processingText) return null;
    _processingText = true;

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFilePath(image.path);
      final result = await recognizer.processImage(input);
      return result.text;
    } catch (e) {
      debugPrint('Text scan failed: $e');
      return null;
    } finally {
      _processingText = false;
      await recognizer.close();
    }
  }
}
