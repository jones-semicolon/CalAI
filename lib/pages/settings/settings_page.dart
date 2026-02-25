import 'package:calai/enums/user_enums.dart';
import 'package:calai/features/reminders/presentation/reminder_settings_section.dart';
import 'package:calai/pages/settings/terms_feedback_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/pages/settings/preference_selection.dart';
import 'package:calai/providers/user_provider.dart';
import '../auth/auth.dart';
import '../shell/widgets/widget_app_bar.dart';
import 'logout_section.dart';
import 'widgets/name_age_card.dart';
import 'widgets/invite_friends_item.dart';
import 'widgets/settings_group.dart';

class SettingsPage extends ConsumerWidget { 
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(userProvider.select((u) => u.profile.provider));
    final bool isAnonymous = provider == null || provider == UserProvider.anonymous;

    return CustomScrollView(
      slivers: [
        const WidgetTreeAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NameAgeCard(),
                if (isAnonymous) ...[
                  const SizedBox(height: 12),
                  const _LinkAccountButton(),
                ],
                const SizedBox(height: 16),
                const InviteFriendsItem(),
                const SizedBox(height: 16),
                const SettingsGroup(),
                const SizedBox(height: 16),
                const PreferencesSection(),
                const SizedBox(height: 16),

                const ReminderSettingsSection(),
                const SizedBox(height: 16),
                TermsFeedbackSection(isAnonymous: isAnonymous ? UserProvider.anonymous : provider),

                if (!isAnonymous) ...[
                  const SizedBox(height: 16),
                  const LogoutSection(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LinkAccountButton extends ConsumerWidget {
  const _LinkAccountButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.splashColor.withOpacity(0.5),
          ),
        ),
        child: InkWell(
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CupertinoActivityIndicator(radius: 15)),
            );

            try {
              await AuthService.linkGoogleAccount(); 
              
              if (context.mounted) {
                Navigator.pop(context); 
              }
            } catch (e) {
              if (context.mounted) {
                Navigator.pop(context); 
                
                if (e is FirebaseAuthException && e.code == 'credential-already-in-use') {
                  _showSwitchAccountDialog(context);
                } else {
                  _handleLinkingError(context, e);
                }
              }
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Icon(Icons.cloud_upload_outlined, color: theme.colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Backup your data",
                        style: textStyle?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Sign in to sync your progress & goals",
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _handleLinkingError(BuildContext context, dynamic e) {

  if (e is FirebaseAuthException && e.code == 'credential-already-in-use') {
    _showSwitchAccountDialog(context);
    return; 
  }
}

void _showSwitchAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      title: const Text("Account Already Exists"),
      content: const Text(
        "This Google account is already linked to another Cal AI profile. "
        "Would you like to switch to that account? \n\n"
        "Note: Current guest progress will be lost.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          onPressed: () async {
            Navigator.pop(context); // Close dialog
            try {
              await AuthService.signInWithGoogle(); 
            } catch (error) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to switch accounts.")),
                );
              }
            }
          },
          child: const Text("Switch Account"),
        ),
      ],
    ),
  );
}