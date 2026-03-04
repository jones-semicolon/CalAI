import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import '../onboarding_widgets/header.dart';
import 'package:calai/l10n/l10n.dart';

class OnboardingStep11 extends StatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep11({super.key, required this.nextPage});

  @override
  State<OnboardingStep11> createState() => _OnboardingStep11State();
}

class _OnboardingStep11State extends State<OnboardingStep11> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(title: context.l10n.step11PotentialTitle),
          Spacer(),
          
          ConfirmationButtonWidget(onConfirm: () => widget.nextPage())
        ],
      ),
    );
  }
}
