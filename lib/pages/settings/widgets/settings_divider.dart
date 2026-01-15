import 'package:flutter/material.dart';

/// A reusable divider widget for separating settings.
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
