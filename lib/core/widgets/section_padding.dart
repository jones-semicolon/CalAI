import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import '../constants/app_sizes.dart';

class SectionPadding extends StatelessWidget {
  final Widget child;

  const SectionPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: child,
    );
  }
}
