import 'package:calai/onboarding/app_entry.dart';
import 'package:calai/pages/auth/auth.dart';
import 'package:calai/pages/settings/settings_item.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../auth/auth-page.dart';

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 185, 168, 209),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: SettingsItemTile(label: "Logout", icon: Icons.logout, // inside LogoutSection
        onTap: () async {
          // 1. Show a loading indicator if desired
          // 2. Await the sign-out to ensure tokens are cleared
          await AuthService.signOut();

          if (context.mounted) {
            // 3. Clear the entire navigation stack and go to AppEntry or AuthPage
            // Replace 'AppEntry()' with the name of your initial root widget
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AppEntry()),
                  (route) => true,
            );
          }
        },)
    );
  }
}
