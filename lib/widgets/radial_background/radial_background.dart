import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
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
    final scaffoldColor = Theme.of(context).colorScheme.surface;
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
