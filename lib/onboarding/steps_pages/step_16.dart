import 'package:calai/onboarding/onboarding_widgets/header.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_widgets/referal_widget.dart';

class OnboardingStep16 extends ConsumerWidget {
  final VoidCallback nextPage;
  const OnboardingStep16({super.key, required this.nextPage});
  static void _handleReferral(String code) {
    //api call to submit referral code
    debugPrint('Referral submitted: $code');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          Header(
            title: context.l10n.step16ReferralTitle,
            subtitle: context.l10n.step16ReferralSubtitle,
          ),
          const Spacer(),

          ReferralCodeInput(onSubmit: _handleReferral),

          const Spacer(),
          ConfirmationButtonWidget(onConfirm: nextPage)
        ],
      ),
    );
  }
}
