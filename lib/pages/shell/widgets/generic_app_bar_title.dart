import 'package:flutter/material.dart';

/// A simple, reusable title widget for the app bar that displays a given text.
class GenericAppBarTitle extends StatelessWidget {
  final String title;

  const GenericAppBarTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
