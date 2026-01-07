import 'package:calai/pages/settings/settings_item.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

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
      child: SettingsItemTile(label: "Logout", icon: Icons.logout, onTap: () {
        // TODO: logout
      },)
    );
  }
}
