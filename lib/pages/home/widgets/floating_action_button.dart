import 'package:calai/pages/home/floating_grid/log_exercise/log_exercise.dart';
import 'package:flutter/material.dart';

import '../floating_grid/food_database/food_database.dart';

/// A widget that displays a 2x2 grid of action buttons.
///
/// This grid is designed to float at the bottom of the screen and uses an
/// [AnimatedPadding] to smoothly slide up when the system keyboard appears,
/// preventing the keyboard from covering the buttons.
class FloatingActionGrid extends StatelessWidget {
  const FloatingActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 75,
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
                /// --- First Row of Buttons ---
                _ActionRow(
                  children: [
                    ActionGridButton(
                      icon: Icons.fitness_center,
                      label: "Log Exercise",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LogExercisePage(),
                          ),
                        );
                      },
                    ),
                    ActionGridButton(
                      icon: Icons.bookmark_outline,
                      label: "Saved Foods",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FoodDatabasePage(selectedTabIndex: 3),
                          ),
                        );                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// --- Second Row of Buttons ---
                _ActionRow(
                  children: [
                    ActionGridButton(
                      icon: Icons.search,
                      label: "Food Database",
                      onTap: () {
                        // debugPrint("Food Database tapped");

                        // ✅ Example navigation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FoodDatabasePage(),
                          ),
                        );
                      },
                    ),
                    ActionGridButton(
                      icon: Icons.qr_code_scanner,
                      label: "Scan Food",
                      onTap: () {
                        debugPrint("Scan Food tapped");
                      },
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
      children: children
          .map(
            (child) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: child,
          ),
        ),
      )
          .toList(),
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
  final VoidCallback? onTap;

  const ActionGridButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}