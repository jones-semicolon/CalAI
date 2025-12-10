import 'package:flutter/material.dart';

class LowerEndFloatFABLocation implements FloatingActionButtonLocation {
  final double yoffset; // how much lower to move it (positive = down)
  final double xoffset; // how much lower to move it (positive = down)

  const LowerEndFloatFABLocation([this.yoffset = 0, this.xoffset = 0]);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final original = FloatingActionButtonLocation.endFloat
        .getOffset(scaffoldGeometry);

    return Offset(
      original.dx + xoffset,
      original.dy + yoffset, // move FAB down
    );
  }
}
