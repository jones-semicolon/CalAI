import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

/// A dialog widget designed to display information about the user's day streak.
///
/// This widget is presented as a centered card with a consistent, theme-aware
/// design. It's intended to be shown modally using `showDialog`.
class DayStreakDialog extends StatelessWidget {
  const DayStreakDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Access theme and media query for consistent, responsive styling.
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;

    return Center(
      child: Material(
        // Use a theme-aware color for the dialog background.
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: SizedBox(
          // Set size relative to the screen for responsiveness.
          width: size.width * 0.9,
          height: size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use pre-defined text styles from the theme for consistency.
              Text(
                "Day Streak",
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "Day Streak Placeholder",
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}