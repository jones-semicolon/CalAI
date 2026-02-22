import 'package:flutter/material.dart';
import '../scan_mode.dart';
import 'scan_corner.dart';
import 'dim_outside_painter.dart';

class ScanFrameOverlay extends StatelessWidget {
  final Rect frame;
  final ScanMode mode;

  const ScanFrameOverlay({super.key, required this.frame, required this.mode});

  @override
  Widget build(BuildContext context) {
    final isBarcode = mode == ScanMode.barcode;
    final radius = isBarcode ? 12.0 : 16.0;

    return Stack(
      children: [
        if (isBarcode)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: DimOutsidePainter(frame, radius)),
            ),
          ),

        Positioned.fromRect(
          rect: frame,
          child: isBarcode
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: Colors.white70, width: 4),
                  ),
                )
              : Stack(
                  children: const [
                    Align(
                      alignment: Alignment.topLeft,
                      child: ScanCorner(
                        radius: BorderRadius.only(topLeft: Radius.circular(16)),
                        top: true,
                        left: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ScanCorner(
                        radius: BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                        top: true,
                        right: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ScanCorner(
                        radius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                        bottom: true,
                        left: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ScanCorner(
                        radius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                        bottom: true,
                        right: true,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
