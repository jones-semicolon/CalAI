import 'package:flutter/material.dart';
import 'radial_blur_layer.dart';
import 'radial_blob_config.dart';

class RadialBackground extends StatelessWidget {
  final Widget child;

  const RadialBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Base scaffold color
        Container(color: scaffoldColor),

        // Decorative blobs
        ...radialBlobs(screenHeight),

        // Blur overlay
        const RadialBlurLayer(),

        // App content
        child,
      ],
    );
  }
}
