import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../pages/auth/auth.dart';
import '../../pages/shell/widget_tree.dart';
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
  bool _isLoading = false;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

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

  Future<void> _handleGoogleSignIn() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await AuthService.signInWithGoogle();

      if (!mounted) return;

      if (userCredential != null && userCredential.user != null) {

        if (!mounted) return;
        await _controller.reverse();

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
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              onGoogleSignIn: _handleGoogleSignIn,
              onSkip: _handleAction,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
