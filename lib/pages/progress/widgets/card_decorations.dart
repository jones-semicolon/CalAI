import 'package:flutter/material.dart';

/// A shared decoration for cards on the progress page.
///
/// Provides a consistent background color, border, and rounded corners.
BoxDecoration progressCardDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Theme.of(context).splashColor, width: 2),
    );
