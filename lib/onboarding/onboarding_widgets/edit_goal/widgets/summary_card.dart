import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int value;
  final IconData icon;
  final Color color; // accent color

  const SummaryCard({
    super.key,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 120,
            width: 110,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Scaled ring (static 50%)
                Transform.scale(
                  scale: 2.5,
                  child: CircularProgressIndicator(
                    value: 0.5,
                    strokeWidth: 2,
                    color: color,
                    backgroundColor: scheme.onTertiary,
                  ),
                ),

                // Icon badge
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: scheme.onTertiary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Value text
          Expanded(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
