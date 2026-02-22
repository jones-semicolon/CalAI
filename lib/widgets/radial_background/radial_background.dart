import 'package:calai/widgets/radial_background/radial_blob_config.dart';
import 'package:calai/widgets/radial_background/radial_blur_layer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadialBackground extends StatelessWidget {
  final Widget child;

  const RadialBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Theme.of(context).colorScheme.surface;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Group static elements into a single repaint layer
        RepaintBoundary(
          child: Stack(
            children: [
              Container(color: scaffoldColor), // Base color
              ...radialBlobs(screenHeight),   // Static blobs
              const RadialBlurLayer(),        // Static blur
            ],
          ),
        ),

        // App content remains in its own layer for smooth interaction
        child,
      ],
    );
  }
}