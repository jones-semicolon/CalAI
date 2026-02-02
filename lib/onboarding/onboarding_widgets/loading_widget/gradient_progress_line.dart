import 'dart:math';
import 'package:flutter/material.dart';

class GradientProgressLine extends StatelessWidget {
  final double value;

  const GradientProgressLine({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            Container(color: const Color.fromARGB(255, 240, 240, 240)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: max(0.02, value),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEF6A6A), Color(0xFF6CA8FF)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
