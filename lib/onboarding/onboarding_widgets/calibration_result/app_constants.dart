import 'package:flutter/material.dart';

/// -------------------------------------------------------------------------
/// Colours
/// -------------------------------------------------------------------------
class AppColors {
  static Color scaffoldBg(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color circularBg(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;

  static Color border(BuildContext context) => Theme.of(context).dividerColor;

  static Color value(BuildContext context) => Theme.of(context).highlightColor;

  static const Color cardBg = Color(0xFF1F1F1F);

  static const Color editIcon = Colors.grey;
  static const Color ringBg = Colors.white12;

  static Color calories(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;

  static const Color carbs = Color.fromARGB(255, 222, 154, 105);
  static const Color protein = Color.fromARGB(255, 221, 105, 105);
  static const Color fats = Color.fromARGB(255, 105, 152, 222);

  static const Color heartIcon = Color.fromARGB(255, 222, 106, 145);
  static const Color healthBarActive = Color.fromARGB(255, 132, 224, 125);
}

/// -------------------------------------------------------------------------
/// Spacing / radii
/// -------------------------------------------------------------------------
class AppSpacing {
  static const double xxxSmall = 2.0;
  static const double xxSmall = 4.0;
  static const double xSmall = 6.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xLarge = 25.0;
}

class AppRadius {
  static const double card = 20.0;
  static const double badge = 12.0;
  static const double progressBar = 8.0;
}

/// -------------------------------------------------------------------------
/// Text styles
/// -------------------------------------------------------------------------
class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );

  static const TextStyle value = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  static const TextStyle score = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white70,
  );
  static const TextStyle headTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.white70,
  );
}

