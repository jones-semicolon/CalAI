import 'package:calai/pages/settings/screens/edit_goals.dart';
import 'package:calai/pages/settings/settings_item.dart';
import 'package:calai/pages/settings/widgets/settings_divider.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

import '../../../widgets/language_card.dart';
import '../weight_history/weight_history_page.dart';

/// A widget that groups a list of settings into an Apple-style list card.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 185, 168, 209),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      // The layout is a Column of items and dividers.
      child: Column(
        children: [
          SettingsItemTile(
            icon: Icons.person_outline,
            label: "Personal Details",
            onTap: () => print("Personal Details tapped"),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.pie_chart_outline,
            label: "Adjust Macronutrients",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditGoalsView())),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.flag_outlined,
            label: "Goal & Current Weight",
            onTap: () => print("Goal tapped"),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.monitor_weight_outlined,
            label: "Weight History",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeightHistoryView())),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.language_outlined,
            label: "Language",
            onTap: () => _showLanguageDialog(context),
          ),
        ],
      ),
    );
  }
}

void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    // This makes the background dark/blurred
    barrierDismissible: true,
    builder: (BuildContext context) {
      // 1. We wrap it in a Dialog to handle basic system behaviors
      return Dialog(
        backgroundColor: Colors.transparent, // Let your Container handle color
        insetPadding: EdgeInsets.zero,       // Use your widget's padding
        child: LanguageCard(
          onClose: () => Navigator.pop(context), // ✅ Close dialog
        ),
      );
    },
  );
}