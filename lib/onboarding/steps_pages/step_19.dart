import 'package:flutter/material.dart';
import '../onboarding_widgets/create_account.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/subscription_page.dart';

class OnboardingStep19 extends StatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep19({super.key, required this.nextPage});

  @override
  State<OnboardingStep19> createState() => _OnboardingStep19State();
}

class _OnboardingStep19State extends State<OnboardingStep19> {
  bool _subscriptionOpened = false;

  Future<void> _handleAction() async {
    // Skip subscription if already opened once
    if (_subscriptionOpened) {
      widget.nextPage();
      return;
    }

    // Open subscription page and wait for close
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SubscriptionPage(onFinished: () => Navigator.pop(context)),
      ),
    );

    // Mark as completed after returning
    setState(() {
      _subscriptionOpened = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Header(title: 'Create an account'),
          const Spacer(),

          // CTA actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CreateAccount(
              onGoogleSignIn: _handleAction,
              onSkip: _handleAction,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
