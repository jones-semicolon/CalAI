import 'package:calai/pages/settings/terms_feedback_section.dart';
import 'package:flutter/material.dart';
import 'package:calai/pages/settings/preference_selection.dart';
import 'logout_section.dart';
import 'widgets/name_age_card.dart';
import 'widgets/invite_friends_item.dart';
import 'widgets/settings_group.dart';

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
          SizedBox(height: 16),
          PreferencesSection(),
          SizedBox(height: 16),
          TermsFeedbackSection(),
          SizedBox(height: 16),
          LogoutSection(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
