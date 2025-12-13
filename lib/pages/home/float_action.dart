import 'package:flutter/material.dart';

class FloatActionContent extends StatelessWidget {
  const FloatActionContent({super.key});

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
                  children: [
                    Expanded(
                      child: _actionButton(
                        context: context,
                        icon: Icons.fitness_center,
                        label: "Log Exercise",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _actionButton(
                        context: context,
                        icon: Icons.bookmark_outline,
                        label: "Save Foods",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// --- Row 2 ---
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        context: context,
                        icon: Icons.search,
                        label: "Food Database",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _actionButton(
                        context: context,
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

  /// -------- Action Button Widget --------
  Widget _actionButton({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).appBarTheme.backgroundColor, // 🔥 White background added
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface, // Border
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12), // Responsive padding
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15), // Rounded circle
            ),
            child: Icon(
              icon,
              size: 28,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
