import 'package:calai/pages/settings/preference_selection.dart';
import 'package:flutter/material.dart';
import 'package:calai/data/notifiers.dart';
import './edit_name.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);
    final bgColor = Theme.of(context).appBarTheme.backgroundColor;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------
          // NAME + AGE CARD
          // ----------------------------
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // PROFILE ICON
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outlined, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditNamePage(),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: changeName,
                          builder: (context, name, child) {
                            return Row(
                              children: [
                                Text(
                                  name.isEmpty ? "Enter your name" : name,
                                  style: TextStyle(
                                    color: Theme.of(context).highlightColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.grey.shade700,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "17 years old",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------
          // INVITE FRIENDS ITEM
          // ----------------------------
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.group_outlined,
                    size: 26,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                Text("Invite Friends", style: textStyle),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ----------------------------
          // SETTINGS GROUP SECTION (APPLE STYLE)
          // ----------------------------
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _settingsItem(
                  context,
                  icon: Icons.person_outline,
                  label: "Personal Details",
                  textStyle: textStyle,
                  onTap: () => print("Personal Details tapped"),
                ),
                _divider(),
                _settingsItem(
                  context,
                  icon: Icons.pie_chart_outline,
                  label: "Adjust Macronutrients",
                  textStyle: textStyle,
                  onTap: () => print("Adjust Macro tapped"),
                ),
                _divider(),
                _settingsItem(
                  context,
                  icon: Icons.flag_outlined,
                  label: "Goal & Current Weight",
                  textStyle: textStyle,
                  onTap: () => print("Goal tapped"),
                ),
                _divider(),
                _settingsItem(
                  context,
                  icon: Icons.monitor_weight_outlined,
                  label: "Weight History",
                  textStyle: textStyle,
                  onTap: () => print("Weight History tapped"),
                ),
                _divider(),
                _settingsItem(
                  context,
                  icon: Icons.language_outlined,
                  label: "Language",
                  textStyle: textStyle,
                  onTap: () => print("Language tapped"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          PreferencesSection(),
        ],
      ),
    );
  }

  // APPLE STYLE LIST ITEM
  Widget _settingsItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required TextStyle? textStyle,
    required Function() onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: Colors.black87),
            ),
            const SizedBox(width: 16),
            Text(label, style: textStyle),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }

  // THIN DIVIDER LIKE IOS
  Widget _divider() => Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    height: 1,
    color: Colors.black26,
  );
}
