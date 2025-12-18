import 'dart:ui';
import 'package:flutter/material.dart';

class RadialBackground extends StatelessWidget {
  final Widget child;

  const RadialBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        // Base scaffold color
        Container(color: scaffoldColor),

        // Red blob – top right
        Positioned(
          right: -130,
          top: -130,
          child: _blob(
            color: const Color.fromARGB(50, 236, 158, 129),
            size: 400,
          ),
        ),

        Positioned(
          left: -130,
          top: -130,
          child: _blob(
            color: const Color.fromARGB(19, 0, 0, 59),
            size: 360,
          ),
        ),

        // Blue blob – middle right
        Positioned(
          right: -100,
          top: MediaQuery.of(context).size.height * 0.13,
          child: _blob(
            color: const Color.fromARGB(50, 194, 177, 218),
            size: 340,
          ),
        ),

        // Purple blob – middle left
        Positioned(
          left: -130,
          top: MediaQuery.of(context).size.height * 0.15,
          child: _blob(
            color: const Color.fromARGB(50, 147, 191, 202),
            size: 320,
          ),
        ),

        
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Your app content on top
        child,
      ],
    );
  }

  // Helper widget to create circular radial blobs
  Widget _blob({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          radius: 0.9,
        ),
      ),
    );
  }
}
