import 'package:calai/enums/user_enums.dart';
import 'package:calai/pages/settings/terms_feedback_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ Add this
import 'package:calai/pages/settings/preference_selection.dart';
import 'package:calai/providers/user_provider.dart'; // ✅ Add your user provider
import '../shell/widgets/widget_app_bar.dart';
import 'logout_section.dart';
import 'widgets/name_age_card.dart';
import 'widgets/invite_friends_item.dart';
import 'widgets/settings_group.dart';

// ✅ Change to ConsumerWidget
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch the user's anonymous status
    final isAnonymous = ref.watch(userProvider.select((u) => u.profile.provider));

    return CustomScrollView(
      key: const PageStorageKey('settings_scroll'),
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
            const SizedBox(height: 16),
            TermsFeedbackSection(isAnonymous: isAnonymous),
            const SizedBox(height: 16),

            // ✅ Conditional Rendering
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
          // Using a subtle primary color tint to make it stand out from regular settings
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.splashColor.withOpacity(0.5),
          ),
        ),
        child: InkWell(
          onTap: () {
            // TODO: Trigger your Auth Link logic (e.g., Google Sign-In)
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