import 'package:flutter/material.dart';
import 'package:calai/l10n/l10n.dart';
import '../../pages/auth/auth.dart';
import '../onboarding_widgets/create_account.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/subscription_page.dart';

class OnboardingStep19 extends StatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep19({super.key, required this.nextPage});

  @override
  State<OnboardingStep19> createState() => _OnboardingStep19State();
}

class _OnboardingStep19State extends State<OnboardingStep19> with SingleTickerProviderStateMixin {
  bool _subscriptionOpened = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller (needed for your reverse() call later)
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    // Check for existing session immediately
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ NEW METHOD: Check if user exists and skip
  Future<void> _checkLoginStatus() async {
    final user = AuthService.getCurrentUser(); // Assuming this is sync or returns User?

    if (!user!.isAnonymous) {
      // Use addPostFrameCallback to ensure navigation happens AFTER the build
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          widget.nextPage();
        }
      });
    }
  }

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

    try {
      final currentUser = AuthService.getCurrentUser();

      // ✅ Check if we are currently anonymous
      if (currentUser != null && currentUser.isAnonymous) {
        // 1. Link the account to keep existing data
        await AuthService.linkGoogleAccount();
        debugPrint("Anonymous account linked to Google successfully.");
      } else {
        // 2. Fresh sign in (Fallback)
        await AuthService.signInWithGoogle();
        debugPrint("Performed a fresh Google Sign-In.");
      }

      if (!mounted) return;

      // Proceed to subscription or next page
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubscriptionPage(onFinished: () => Navigator.pop(context)),
        ),
      );

      setState(() => _subscriptionOpened = true);
    } catch (e) {
      // Handle "credential-already-in-use" error specifically here!
      // This happens if their Google account is already registered.
      // _handleAuthError(e);
      debugPrint("Google Sign-In Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Header(title: context.l10n.step19CreateAccountTitle),
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
