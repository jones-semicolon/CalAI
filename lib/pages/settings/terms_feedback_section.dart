import 'package:calai/enums/user_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_sizes.dart';
import '../../onboarding/app_entry.dart';
import '../../providers/user_provider.dart';
import 'settings_item.dart';
import 'widgets/settings_divider.dart';

class TermsFeedbackSection extends ConsumerWidget {
  final UserProvider isAnonymous;
  const TermsFeedbackSection({super.key, required this.isAnonymous});

  void _showDeleteAccountConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
            "Are you absolutely sure? This will permanently delete your Cal AI history, weight logs, and custom goals. This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              // Inside your AlertDialog's "Delete Permanently" button
              onPressed: () async {
                try {
                  // Show a loading spinner or some feedback here if possible
                  await ref.read(userProvider.notifier).deleteUserAccount();

                  if (context.mounted) {
                    Navigator.pop(context); // Close dialog
                    // Navigate to your onboarding or entry page
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const AppEntry()),
                          (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: const Text(
                "Delete Permanently",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if (isAnonymous != UserProvider.anonymous) ...[
            const SettingsDivider(),
            SettingsItemTile(
              icon: Icons.delete_outline,
              label: "Delete Account?",
              onTap: () => _showDeleteAccountConfirmation(context, ref),
            ),
          ],
        ],
      ),
    );
  }
}
