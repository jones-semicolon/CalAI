import 'dart:ui';
import 'package:flutter/material.dart';

class RadialBlurLayer extends StatelessWidget {
  const RadialBlurLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      // Adding a RepaintBoundary prevents the heavy blur filter
      // from re-calculating if the blobs underneath haven't changed.
      child: RepaintBoundary(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}