import 'package:calai/enums/user_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Added import

import '../../core/constants/app_sizes.dart';
import '../../onboarding/app_entry.dart';
import '../../providers/user_provider.dart';
import 'settings_item.dart';
import 'widgets/settings_divider.dart';
import 'package:calai/l10n/l10n.dart';

class TermsFeedbackSection extends ConsumerWidget {
  final UserProvider isAnonymous;
  const TermsFeedbackSection({super.key, required this.isAnonymous});

  // ✅ 1. Helper function to properly format and launch the email app
  Future<void> _launchEmail({
    required String subject,
    required String body,
  }) async {
    const String supportEmail = "support@calai.com"; // TODO: Put your actual support email here

    // url_launcher requires manual encoding for mailto queries to handle spaces/newlines correctly
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      debugPrint("Could not launch email: $e");
    }
  }

  void _showDeleteAccountConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.l10n.deleteAccountTitle),
          content: Text(
            context.l10n.deleteAccountMessage,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancelLabel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(userProvider.notifier).deleteUserAccount();

                  if (context.mounted) {
                    Navigator.pop(context); // Close dialog
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
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
              // ✅ 2. Trigger Support Email
              _launchEmail(
                subject: "Cal AI - Support Request",
                body: "Hello Cal AI Team,\n\nI need help with:\n\n\n\n--- App Info ---\n(Please leave this intact so we can help you better)\nApp Version: 1.0\nPlatform: ${Theme.of(context).platform.name} \nUserID: ${ref.read(userProvider)?.id ?? "Unknown"}",
              );
            },
          ),
          const SettingsDivider(),
          SettingsItemTile(
            icon: Icons.lightbulb_outline,
            label: context.l10n.featureRequestLabel,
            onTap: () {
              // ✅ 3. Trigger Feature Request Email
              _launchEmail(
                subject: "Cal AI - Feature Request",
                body: "Hello Cal AI Team,\n\nI would love to see this feature added to the app:\n\n",
              );
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