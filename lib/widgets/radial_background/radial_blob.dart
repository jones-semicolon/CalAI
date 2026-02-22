import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

class RadialBlob extends StatelessWidget {
  final double size;
  final Color color;

  const RadialBlob({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
