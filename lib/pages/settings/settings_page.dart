import 'package:calai/enums/user_enums.dart';
import 'package:calai/pages/settings/terms_feedback_section.dart';
import 'package:calai/providers/global_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/pages/settings/preference_selection.dart';
import 'package:calai/providers/user_provider.dart';
import '../../features/reminders/presentation/reminder_settings_section.dart';
import '../auth/auth.dart';
import '../shell/widgets/widget_app_bar.dart';
import 'logout_section.dart';
import 'widgets/name_age_card.dart';
import 'widgets/invite_friends_item.dart';
import 'widgets/settings_group.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isAnonymous = ref.watch(userProvider.select((u) => u.profile.provider))
        ?? UserProvider.anonymous;

    return CustomScrollView(
      slivers: [
        const WidgetTreeAppBar(),
        SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const NameAgeCard(),
            const SizedBox(height: 12),
            if (isAnonymous == UserProvider.anonymous) ... [
              const _LinkAccountButton(),
              const SizedBox(height: 16),
            ],
            const InviteFriendsItem(),
            const SizedBox(height: 16),
            const SettingsGroup(),
            const SizedBox(height: 16),
            const PreferencesSection(),
            SizedBox(height: 16),
            ReminderSettingsSection(),
            const SizedBox(height: 16),
            TermsFeedbackSection(isAnonymous: isAnonymous),
            const SizedBox(height: 16),

            if (isAnonymous != UserProvider.anonymous) ...[
              const LogoutSection(),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      ]
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
            try {
              final result = await AuthService.linkGoogleAccount();

              // ✅ Check if the widget is still in the tree before using context
              if (!context.mounted) return;

              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Account successfully backed up!")),
                );
              }
            } catch (e) {
              // ✅ Check mounted again before calling error handler
              if (!context.mounted) return;
              _handleLinkingError(context, e);
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
  String message = "Failed to link account.";

  if (e is FirebaseAuthException && e.code == 'credential-already-in-use') {
    message = "This Google account is already linked to another Cal AI profile.";
    // TODO: Show a dialog asking if they want to switch accounts instead
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}