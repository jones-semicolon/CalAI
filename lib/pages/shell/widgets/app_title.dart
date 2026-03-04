import 'package:flutter/material.dart';
import 'package:calai/l10n/l10n.dart';

/// The main title widget for the app bar, displaying the app's logo and name.
class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Image.asset(
          'assets/favicon.png',
          height: 32,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          context.l10n.appTitle,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
