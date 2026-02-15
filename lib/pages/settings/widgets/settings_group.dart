import 'package:calai/pages/settings/screens/edit_goals.dart';
import 'package:calai/pages/settings/settings_item.dart';
import 'package:calai/pages/settings/widgets/settings_divider.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

import '../../../widgets/language_card.dart';
import '../screens/personal_details.dart';
import '../weight_history/weight_history_page.dart';

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
      child: Column(
        children: [
          SettingsItemTile(
            icon: Icons.person_outline,
            label: "Personal Details",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalDetailsPage())),
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.pie_chart_outline,
            label: "Adjust Macronutrients",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditGoalsView())),
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
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: LanguageCard(
          onClose: () => Navigator.pop(context),
        ),
      );
    },
  );
}