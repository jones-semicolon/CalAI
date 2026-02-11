import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';

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
          Header(title: 'You have great potential to crush your goal'),
          Spacer(), // Animation
          
          ConfirmationButtonWidget(onConfirm: () => widget.nextPage())
        ],
      ),
    );
  }
}
