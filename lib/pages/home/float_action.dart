import 'package:flutter/material.dart';

class FloatActionContent extends StatelessWidget {
  const FloatActionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 90,
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
                        icon: Icons.fitness_center,
                        label: "Log Exercise",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _actionButton(
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
                        icon: Icons.search,
                        label: "Food Database",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _actionButton(
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
  Widget _actionButton({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white, // 🔥 White background added
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey, // Border
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
