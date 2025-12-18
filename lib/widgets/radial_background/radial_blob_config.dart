import 'package:flutter/material.dart';
import 'radial_blob.dart';

List<Widget> radialBlobs(double screenHeight) {
  return [
    Positioned(
      right: -130,
      top: -130,
      child: const RadialBlob(
        size: 400,
        color: Color.fromARGB(50, 236, 158, 129),
      ),
    ),

    Positioned(
      left: -130,
      top: -130,
      child: const RadialBlob(
        size: 360,
        color: Color.fromARGB(19, 0, 0, 59),
      ),
    ),

    Positioned(
      right: -100,
      top: screenHeight * 0.13,
      child: const RadialBlob(
        size: 340,
        color: Color.fromARGB(50, 194, 177, 218),
      ),
    ),

    Positioned(
      left: -130,
      top: screenHeight * 0.15,
      child: const RadialBlob(
        size: 320,
        color: Color.fromARGB(50, 147, 191, 202),
      ),
    ),
  ];
}
