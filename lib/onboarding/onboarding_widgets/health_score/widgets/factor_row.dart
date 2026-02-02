import 'package:flutter/material.dart';

class FactorRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FactorRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.onPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.onPrimary,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: colors.onSecondary),
          ),
        ],
      ),
    );
  }
}
