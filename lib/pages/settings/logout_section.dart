import 'package:calai/main.dart';
import 'package:calai/onboarding/app_entry.dart';
import 'package:calai/pages/settings/settings_item.dart';
import 'package:calai/providers/auth_state_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/l10n/l10n.dart';
import '../../core/constants/app_sizes.dart';

class LogoutSection extends ConsumerWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 185, 168, 209),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: SettingsItemTile(
        label: context.l10n.logoutTitle,
        icon: Icons.logout,
        onTap: () => _showLogoutConfirmation(context, ref),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(context.l10n.logoutTitle),
          content: Text(context.l10n.logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text(context.l10n.cancelLabel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CupertinoActivityIndicator()),
                );

                try {
                  await ref.read(authServiceProvider).logout();
                  
                  appNavigatorKey.currentState?.pop();
                  appNavigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AppEntry()),
                    (route) => false, 
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  debugPrint("Logout Error: $e");
                }
              },
              child: Text(
                context.l10n.logoutLabel,
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }
}