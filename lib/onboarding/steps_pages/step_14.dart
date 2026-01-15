import 'package:flutter/material.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/yes_no_button.dart';

class OnboardingStep14 extends StatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep14({super.key, required this.nextPage});

  @override
  State<OnboardingStep14> createState() => _OnboardingStep14State();
}

class _OnboardingStep14State extends State<OnboardingStep14> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(title: 'Add calories burned back to your daily goal?'),
          Spacer(),
          NoYesButton(
            onNo: widget.nextPage,
            onYes: () {
              //TODO : trigger switch from settings calories burned
              widget.nextPage();
            },
          ),
        ],
      ),
    );
  }
}
