import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageCropper {
  static Future<XFile?> cropToFrame(XFile image, Rect normalizedFrame) async {
    try {
      final safeFrame = normalizedFrame.intersect(
        const Rect.fromLTWH(0, 0, 1, 1),
      );
      if (safeFrame.isEmpty) return null;

      final bytes = await image.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;

      final oriented = img.bakeOrientation(decoded);

      final left = (safeFrame.left * oriented.width).round().clamp(
        0,
        oriented.width - 1,
      );
      final top = (safeFrame.top * oriented.height).round().clamp(
        0,
        oriented.height - 1,
      );
      final width = (safeFrame.width * oriented.width).round().clamp(
        1,
        oriented.width - left,
      );
      final height = (safeFrame.height * oriented.height).round().clamp(
        1,
        oriented.height - top,
      );

      final cropped = img.copyCrop(
        oriented,
        x: left,
        y: top,
        width: width,
        height: height,
      );

      final file = File(
        '${Directory.systemTemp.path}/calai_frame_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await file.writeAsBytes(img.encodeJpg(cropped, quality: 92));
      return XFile(file.path);
    } catch (e) {
      debugPrint('Crop failed: $e');
      return null;
    }
  }
}
