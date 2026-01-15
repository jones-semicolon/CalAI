import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

class RadialBlurLayer extends StatelessWidget {
  const RadialBlurLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
