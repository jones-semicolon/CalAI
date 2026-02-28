import 'package:calai/main.dart';
import 'package:calai/onboarding/app_entry.dart';
import 'package:calai/pages/settings/settings_item.dart';
import 'package:calai/providers/auth_state_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        label: "Logout",
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
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Navigator.pop(context); 
                appNavigatorKey.currentState?.pop();

                showDialog(
                  context: context,
                  barrierDismissible: false, // Prevents user from tapping outside to close
                  builder: (BuildContext context) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  },
                );

                // 3. Run the heavy background tasks (clearing cache, terminating Firestore)
                await ref.read(authServiceProvider).logout();

                // if (!context.mounted) return;

                appNavigatorKey.currentState?.pop();
                appNavigatorKey.currentState?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AppEntry()),
                  (route) => false, 
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }
}