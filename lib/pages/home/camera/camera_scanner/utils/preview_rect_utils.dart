import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../scan_mode.dart';

class PreviewRectUtils {
  /// Visible camera preview rect on screen
  static Rect? previewRect(CameraController? controller, Size screen) {
    if (controller == null || !controller.value.isInitialized) return null;

    final rawAspect = controller.value.aspectRatio;
    final isPortrait = screen.height >= screen.width;
    final previewAspect = isPortrait ? (1 / rawAspect) : rawAspect;
    final screenAspect = screen.width / screen.height;

    if (screenAspect > previewAspect) {
      final height = screen.height;
      final width = height * previewAspect;
      final dx = (screen.width - width) / 2;
      return Rect.fromLTWH(dx, 0, width, height);
    } else {
      final width = screen.width;
      final height = width / previewAspect;
      final dy = (screen.height - height) / 2;
      return Rect.fromLTWH(0, dy, width, height);
    }
  }

  /// Actual scanner frame shown to the user
  static Rect calculateFrame({
    required Size screen,
    required ScanMode mode,
    required EdgeInsets safePadding,
  }) {
    const topOffset = 70.0;
    const bottomControlsHeight = 164.0;
    const bottomOffset = 40.0;

    final availableHeight =
        screen.height -
        safePadding.top -
        safePadding.bottom -
        topOffset -
        bottomControlsHeight -
        bottomOffset;

    final isBarcode = mode == ScanMode.barcode;
    final isSmall = screen.width < 360;

    double frameWidth;
    double frameHeight;

    if (isBarcode) {
      const barcodeAspect = 3.2; // wide + short
      final maxWidth = screen.width >= 900
          ? 520.0
          : screen.width * (isSmall ? 0.78 : 0.86);
      final minWidth = isSmall ? 200.0 : 280.0;

      frameWidth = maxWidth.clamp(minWidth, maxWidth);
      frameHeight = frameWidth / barcodeAspect;

      if (frameHeight > availableHeight) {
        frameHeight = availableHeight;
        frameWidth = frameHeight * barcodeAspect;
      }
    } else {
      final maxWidth = screen.width >= 900 ? 420.0 : 360.0;
      final minWidth = isSmall ? 250.0 : 220.0;

      frameWidth = (screen.width * (isSmall ? 0.85 : 1)).clamp(
        minWidth,
        maxWidth,
      );
      frameHeight = frameWidth * (3 / 4);

      if (frameHeight > availableHeight) {
        frameHeight = availableHeight;
        frameWidth = frameHeight * (4 / 3);
      }
    }

    final spare = (availableHeight - frameHeight).clamp(0.0, 9999.0);
    final topSpacer = spare * (isBarcode ? 0.5 : 0.2);

    final top = safePadding.top + topOffset + topSpacer;
    final left = (screen.width - frameWidth) / 2;

    return Rect.fromLTWH(left, top, frameWidth, frameHeight);
  }

  /// Convert visible frame → normalized (0–1) for cropping
  static Rect normalize(Rect frame, Rect preview) {
    return Rect.fromLTWH(
      (frame.left - preview.left) / preview.width,
      (frame.top - preview.top) / preview.height,
      frame.width / preview.width,
      frame.height / preview.height,
    ).intersect(const Rect.fromLTWH(0, 0, 1, 1));
  }
}
