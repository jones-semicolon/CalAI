import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';
import '../onboarding_widgets/continue_button.dart';

class OnboardingStep12 extends StatelessWidget {
  final VoidCallback nextPage;

  const OnboardingStep12({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Text(
                  context.tr('Thank you for\ntrusting us!'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  context.tr("Now let's personalize Cal AI for you..."),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),

                const SizedBox(height: 48),

                /// Privacy Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.tr('Your privacy and security matter to us.'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        context.tr(
                          'We promise to always keep your\npersonal information private and secure.',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ContinueButton(enabled: true, onNext: nextPage),
          ),
        ],
      ),
    );
  }
}
