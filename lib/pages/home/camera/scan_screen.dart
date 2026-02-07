import 'package:flutter/material.dart';

import 'camera_scanner/camera_scanner_widget.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraScannerWidget(
        onImageCaptured: (image) {
          debugPrint('Captured image: ${image.path}');
        },
        onBarcodeCaptured: (barcode) {
          debugPrint('Barcode data: $barcode');
        },
        onFoodLabelCaptured: (text) {
          debugPrint('Food label text: $text');
        },
        onGalleryPicked: (image) {
          debugPrint('Gallery image: ${image.path}');
        },
      ),
    );
  }
}
