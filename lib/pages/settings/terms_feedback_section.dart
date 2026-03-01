import 'package:calai/enums/user_enums.dart';
import 'package:calai/l10n/l10n.dart';
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
          title: Text(context.l10n.deleteAccountTitle),
          content: Text(context.l10n.deleteAccountMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancelLabel),
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
              child: Text(
                context.l10n.deletePermanentlyLabel,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
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
            label: context.l10n.termsAndConditionsLabel,
            onTap: () {
              // TODO: navigate to Terms
              print("Terms tapped");
            },
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.privacy_tip_outlined,
            label: context.l10n.privacyPolicyLabel,
            onTap: () {
              // TODO: navigate to Privacy Policy
              print("Privacy tapped");
            },
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.email_outlined,
            label: context.l10n.supportEmailLabel,
            onTap: () {
              // TODO: open email client
              print("Support tapped");
            },
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.lightbulb_outline,
            label: context.l10n.featureRequestLabel,
            onTap: () {
              // TODO: open feedback form
              print("Feature Request tapped");
            },
          ),
          if (isAnonymous != UserProvider.anonymous) ...[
            const SettingsDivider(),
            SettingsItemTile(
              icon: Icons.delete_outline,
              label: context.l10n.deleteAccountQuestion,
              onTap: () => _showDeleteAccountConfirmation(context, ref),
            ),
          ],
        ],
      ),
    );
  }
}
