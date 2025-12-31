import 'package:flutter/material.dart';
import 'package:calai/pages/settings/preference_selection.dart';
import 'package:calai/data/notifiers.dart';
import 'edit_name.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 12),
          NameAgeCard(),
          SizedBox(height: 12),
          InviteFriendsItem(),
          SizedBox(height: 16),
          SettingsGroup(),
          SizedBox(height: 30),
          PreferencesSection(),
        ],
      ),
    );
  }
}

/// ----------------------------
/// NAME + AGE CARD
/// ----------------------------
class NameAgeCard extends StatelessWidget {
  const NameAgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bgColor = Theme.of(context).colorScheme.surface;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).splashColor.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromARGB(26, 185, 168, 209),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outlined, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditNamePage()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: changeName,
                    builder: (context, name, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            name.isEmpty ? "Enter your name" : name,
                            style: TextStyle(color: textColor),
                          ),
                          SizedBox(width: 5),
                          if (name.isEmpty)
                            Icon(Icons.edit, size: 18, color: Colors.grey),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text("17 years old", style: TextStyle(color: primaryColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------
/// INVITE FRIENDS ITEM
/// ----------------------------
class InviteFriendsItem extends StatelessWidget {
  const InviteFriendsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).splashColor.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Icon(Icons.group_outlined, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 10),
          Text("Invite friends", style: textStyle),
          const Spacer(),
        ],
      ),
    );
  }
}

/// ----------------------------
/// SETTINGS GROUP (APPLE STYLE)
/// ----------------------------
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color.fromARGB(26, 185, 168, 209),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _settingsItem(context, Icons.person_outline, "Personal Details", textStyle, () => print("Personal Details tapped")),
          _divider(context),
          _settingsItem(context, Icons.pie_chart_outline, "Adjust Macronutrients", textStyle, () => print("Adjust Macro tapped")),
          _divider(context),
          _settingsItem(context, Icons.flag_outlined, "Goal & Current Weight", textStyle, () => print("Goal tapped")),
          _divider(context),
          _settingsItem(context, Icons.monitor_weight_outlined, "Weight History", textStyle, () => print("Weight History tapped")),
          _divider(context),
          _settingsItem(context, Icons.language_outlined, "Language", textStyle, () => print("Language tapped")),
        ],
      ),
    );
  }

  Widget _settingsItem(BuildContext context, IconData icon, String label, TextStyle? textStyle, Function() onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(4), child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(width: 10),
            Text(label, style: textStyle),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) => Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    height: 1.5,
    color: Theme.of(context).hintColor,
  );
}
