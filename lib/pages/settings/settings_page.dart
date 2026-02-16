import 'package:flutter/material.dart';
import 'package:calai/features/reminders/presentation/reminder_settings_section.dart';
import 'profile_card_section.dart';
import 'invite_friends_section.dart';
import 'settings_group_section.dart';
import 'preference_selection.dart';
import 'terms_feedback_section.dart';
import 'logout_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ProfileCardSection(),
          InviteFriendsSection(),
          SizedBox(height: 16),
          SettingsGroupSection(),
          SizedBox(height: 30),
          PreferencesSection(),
          SizedBox(height: 16),
          ReminderSettingsSection(),
          SizedBox(height: 30),
          TermsFeedbackSection(),
          SizedBox(height: 30),
          LogoutSection(),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
