import 'package:flutter/material.dart';
import '../data/notifiers.dart';

/// The main navigation bar widget displayed at the bottom of the scaffold.
///
/// It uses a [ValueListenableBuilder] to reactively build its state
/// based on the `selectedPage` notifier.
class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPage,
      builder: (context, page, child) {
        return IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: "Home",
                  index: 0,
                  selectedIndex: page,
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.show_chart_outlined,
                  selectedIcon: Icons.show_chart,
                  label: "Progress",
                  index: 1,
                  selectedIndex: page,
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  label: "Settings",
                  index: 2,
                  selectedIndex: page,
                ),
              ),
              // This SizedBox creates the empty space for the FAB.
              const SizedBox(width: 100),
            ],
          ),
        );
      },
    );
  }
}

/// An individual item within the [NavBarWidget].
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int selectedIndex;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if this item is selected based on the passed-in index.
    final bool isSelected = selectedIndex == index;
    final Color color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onPrimary;

    return InkWell(
      // borderRadius: BorderRadius.circular(10),
      onTap: () => selectedPage.value = index,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}