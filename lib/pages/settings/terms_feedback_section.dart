import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import 'settings_item.dart';
import 'widgets/settings_divider.dart';

class TermsFeedbackSection extends StatelessWidget {
  const TermsFeedbackSection({super.key});

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
            icon: Icons.description_outlined,
            label: "Terms and Conditions",
            onTap: () {
              // TODO: navigate to Terms
              print("Terms tapped");
            },
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.privacy_tip_outlined,
            label: "Privacy Policy",
            onTap: () {
              // TODO: navigate to Privacy Policy
              print("Privacy tapped");
            },
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.email_outlined,
            label: "Support Email",
            onTap: () {
              // TODO: open email client
              print("Support tapped");
            },
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.lightbulb_outline,
            label: "Feature Request",
            onTap: () {
              // TODO: open feedback form
              print("Feature Request tapped");
            },
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.delete_outline,
            label: "Delete Account?",
            onTap: () {
              // TODO: show delete confirmation
              print("Delete tapped");
            },
          ),
        ],
      ),
    );
  }
}
