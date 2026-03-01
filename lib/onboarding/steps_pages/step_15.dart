import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added
import 'package:calai/l10n/l10n.dart';
import '../../providers/user_provider.dart';           // Added
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/yes_no_button.dart';

class OnboardingStep15 extends ConsumerWidget { // Changed to ConsumerWidget
  final VoidCallback nextPage;
  const OnboardingStep15({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title: context.l10n.step15RolloverQuestion),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 25), // Fixed type
              decoration: BoxDecoration(
                color: theme.colorScheme.onTertiary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.splashColor, width: 1.5),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.l10n.step15RolloverUpTo,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: context.l10n.step15RolloverCap,
                      style: TextStyle(
                        color: Color.fromARGB(255, 105, 152, 222),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            NoYesButton(
              onNo: () {
                ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(settings: s.settings.copyWith(isRollover: false)));
                nextPage();
              },
              onYes: () {
                ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(settings: s.settings.copyWith(isRollover: true)));
                nextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
