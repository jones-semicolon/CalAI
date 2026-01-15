import 'package:flutter/material.dart';

/// A widget that displays a 2x2 grid of action buttons.
///
/// This grid is designed to float at the bottom of the screen and uses an
/// [AnimatedPadding] to smoothly slide up when the system keyboard appears,
/// preventing the keyboard from covering the buttons.
class FloatingActionGrid extends StatelessWidget {
  const FloatingActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // AnimatedPadding automatically animates its child's position when the
    // padding values change. Here, it reacts to the keyboard's height.
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      // `viewInsets.bottom` provides the height of the system keyboard.
      // An additional 120 pixels of padding is added for spacing.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 75,
      ),
      child: const Align(
        alignment: Alignment.bottomCenter,
        // The Material widget ensures that child widgets like InkWell or
        // other Material components render correctly with proper theming.
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// --- First Row of Buttons ---
                _ActionRow(
                  children: [
                    ActionGridButton(
                      icon: Icons.fitness_center,
                      label: "Log Exercise",
                    ),
                    ActionGridButton(
                      icon: Icons.bookmark_outline,
                      label: "Save Foods",
                    ),
                  ],
                ),
                SizedBox(height: 12),
                /// --- Second Row of Buttons ---
                _ActionRow(
                  children: [
                    ActionGridButton(
                      icon: Icons.search,
                      label: "Food Database",
                    ),
                    ActionGridButton(
                      icon: Icons.qr_code_scanner,
                      label: "Scan Food",
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

/// A private helper widget to build a row of action buttons.
class _ActionRow extends StatelessWidget {
  final List<Widget> children;
  const _ActionRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: children.map((child) => Expanded(child: child)).toList(),
    );
  }
}


/// A styled button for use within the [FloatingActionGrid].
///
/// This button features a prominent icon inside a decorated container and a
/// label below it, providing a clear and tappable target.
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
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.splashColor,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The inner container provides a background for the icon.
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: 28,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          // The text label for the button.
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}