import 'package:flutter/material.dart';
import 'settings_item.dart';
import 'divider.dart';
import '../../onboarding/auth_entry/language_card.dart';

class SettingsGroupSection extends StatelessWidget {
  const SettingsGroupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SettingsItemTile(
            icon: Icons.person_outline,
            label: "Personal details",
            onTap: () {},
          ),
          const iosDiv(),
          SettingsItemTile(
            icon: Icons.pie_chart_outline,
            label: "Adjust macronutrients",
            onTap: () {},
          ),
          const iosDiv(),
          SettingsItemTile(
            icon: Icons.flag_outlined,
            label: "Goal & current Weight",
            onTap: () {},
          ),
          const iosDiv(),
          SettingsItemTile(
            icon: Icons.monitor_weight_outlined,
            label: "Weight history",
            onTap: () {},
          ),
          const iosDiv(),
          SettingsItemTile(
            icon: Icons.language_outlined,
            label: "Language",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black26,
                builder: (_) => Center(
                  child: LanguageCard(
                    onClose: () => Navigator.of(context).pop(),
                    onLanguageChanged: (_) => Navigator.of(context).pop(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
