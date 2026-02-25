import 'package:flutter/material.dart';

/// A custom FloatingActionButtonLocation that allows you to
/// offset the FAB lower and/or horizontally from its default `endFloat` position.
class LowerEndFloatFABLocation implements FloatingActionButtonLocation {
  /// Vertical offset in pixels. Positive value moves the FAB downward.
  final double yoffset;

  /// Horizontal offset in pixels. Positive value moves the FAB to the right.
  final double xoffset;

  /// Creates a FAB location offset from the default `endFloat`.
  ///
  /// Example:
  /// ```dart
  /// floatingActionButtonLocation: LowerEndFloatFABLocation(20, 10),
  /// ```
  const LowerEndFloatFABLocation([this.yoffset = 0, this.xoffset = 0]);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Get the default endFloat offset
    final original = FloatingActionButtonLocation.endFloat
        .getOffset(scaffoldGeometry);

    // Apply custom offsets
    return Offset(
      original.dx + xoffset,
      original.dy + yoffset,
    );
  }
}
