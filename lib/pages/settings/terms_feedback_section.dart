import 'package:flutter/material.dart';
import 'settings_item.dart';
import 'divider.dart';

class TermsFeedbackSection extends StatelessWidget {
  const TermsFeedbackSection({super.key});

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
            icon: Icons.description_outlined,
            label: "Terms and Conditions",
            onTap: () {
              // TODO: navigate to Terms
            },
          ),
          const iosDiv(),
          SettingsItemTile(
            icon: Icons.privacy_tip_outlined,
            label: "Privacy Policy",
            onTap: () {
              // TODO: navigate to Privacy Policy
            },
          ),
          const iosDiv(),
          SettingsItemTile(
            icon: Icons.email_outlined,
            label: "Support Email",
            onTap: () {
              // TODO: open email client
            },
          ),
          const iosDiv(),
          SettingsItemTile(
            icon: Icons.lightbulb_outline,
            label: "Feature Request",
            onTap: () {
              // TODO: open feedback form
            },
          ),
          const iosDiv(),
          SettingsItemTile(
            icon: Icons.delete_outline,
            label: "Delete Account?",
            onTap: () {
              // TODO: show delete confirmation
            },
          ),
        ],
      ),
    );
  }
}
