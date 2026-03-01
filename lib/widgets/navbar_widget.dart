import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Added
import '../../../providers/navigation_provider.dart'; // ✅ Your new provider
import '../l10n/l10n.dart';

class NavBarWidget extends ConsumerWidget { // ✅ Changed to ConsumerWidget
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch the current index
    final page = ref.watch(selectedPageProvider);
    final l10n = context.l10n;

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: l10n.homeTab,
              index: 0,
              selectedIndex: page,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.show_chart_outlined,
              selectedIcon: Icons.show_chart,
              label: l10n.progressTab,
              index: 1,
              selectedIndex: page,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              label: l10n.settingsTab,
              index: 2,
              selectedIndex: page,
            ),
          ),
          // Empty space for the center FAB
          const SizedBox(width: 80),
        ],
      ),
    );
  }
}

class _NavItem extends ConsumerWidget { // ✅ Also changed to ConsumerWidget to update state
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
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSelected = selectedIndex == index;
    final theme = Theme.of(context);

    final Color color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary.withOpacity(0.6);

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      // ✅ Update the Riverpod state on tap
      onTap: () => ref.read(selectedPageProvider.notifier).state = index,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
