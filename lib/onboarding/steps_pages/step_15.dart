import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/yes_no_button.dart';

class OnboardingStep15 extends StatelessWidget {
  final VoidCallback nextPage;
  const OnboardingStep15({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: 'Rollover extra calories to the next day?'),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsetsGeometry.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryFixed,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.dividerColor, width: 1.5),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${context.tr('Rollover up to')} ',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '200 ${context.tr('cals')}',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 105, 152, 222),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // No/Yes Buttons
            NoYesButton(
              onNo: nextPage,
              onYes: () {
                // TODO: Trigger settings rollover switch
                nextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
