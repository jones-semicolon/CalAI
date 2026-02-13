import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';
import '../data/notifiers.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPage,
      builder: (context, page, child) {
        return IntrinsicHeight(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.only(bottom: 25, top: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // ⭐ Fixes vertical stretch
              children: [
                Expanded(
                  child: _navItem(
                    context: context,
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: "Home",
                    index: 0,
                    selectedIndex: page,
                  ),
                ),

                Expanded(
                  child: _navItem(
                    context: context,
                    icon: Icons.show_chart_outlined,
                    selectedIcon: Icons.show_chart,
                    label: "Progress",
                    index: 1,
                    selectedIndex: page,
                  ),
                ),

                Expanded(
                  child: _navItem(
                    context: context,
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    label: "Settings",
                    index: 2,
                    selectedIndex: page,
                  ),
                ),

                // FAB space unchanged
                const SizedBox(width: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required int selectedIndex,
  }) {
    final bool selected = index == selectedIndex;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => selectedPage.value = index,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selected ? selectedIcon : icon,
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondary,
            size: 24,
          ),
          const SizedBox(height: 3),
          Text(
            context.tr(label),
            style: TextStyle(
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
