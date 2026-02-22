import 'package:flutter/material.dart';

class CircleBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final IconData icon;
  final double size;

  const CircleBackButton({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.icon = Icons.arrow_back,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? theme.colorScheme.onTertiary.withOpacity(0.6),
        ),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}