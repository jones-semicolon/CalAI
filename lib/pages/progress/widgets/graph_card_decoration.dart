import 'package:flutter/material.dart';

/// A shared decoration for the graph cards on the progress page.
///
/// Provides a consistent background color, border radius, and shadow.
BoxDecoration graphCardDecoration(BuildContext context) => BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Theme.of(context).scaffoldBackgroundColor,
      border: Border.all(color: Theme.of(context).splashColor, width: 2),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
