import 'package:flutter/material.dart';

/// A widget that displays a grid of action buttons with an animated padding
/// that adjusts for the system keyboard.
class FloatingActionGrid extends StatelessWidget {
  const FloatingActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 120,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// --- Row 1 ---
                Row(
                  children: const [
                    Expanded(
                      child: ActionGridButton(
                        icon: Icons.fitness_center,
                        label: "Log Exercise",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ActionGridButton(
                        icon: Icons.bookmark_outline,
                        label: "Save Foods",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// --- Row 2 ---
                Row(
                  children: const [
                    Expanded(
                      child: ActionGridButton(
                        icon: Icons.search,
                        label: "Food Database",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ActionGridButton(
                        icon: Icons.qr_code_scanner,
                        label: "Scan Food",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A custom button widget designed for the Floating Action Grid.
class ActionGridButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionGridButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.onSurface,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: 28,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}