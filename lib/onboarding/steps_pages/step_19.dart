import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

import '../../pages/auth/auth.dart';
import '../../providers/user_provider.dart';
import '../../pages/shell/widget_tree.dart'; 
import '../onboarding_widgets/create_account.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/subscription_page.dart';

class OnboardingStep19 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep19({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep19> createState() => _OnboardingStep19State();
}

class _OnboardingStep19State extends ConsumerState<OnboardingStep19> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ 2. Centralized completion method
  void _finishOnboarding() {
    // Tell the state we are done
    ref.read(userProvider.notifier).completeOnboarding();

    // Safely route to the main app, clearing the onboarding stack
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WidgetTree()),
      (route) => false,
    );
  }

  Future<void> _checkLoginStatus() async {
    final user = AuthService.getCurrentUser(); 

    if (user != null && !user.isAnonymous) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _finishOnboarding(); // ✅ Use the new method
        }
      });
    }
  }

  Future<void> _handleAction() async {
    // Open subscription page and wait for close
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubscriptionPage(onFinished: () => Navigator.pop(context)),
      ),
    );

    // ✅ 3. Automatically finish onboarding once they return from the subscription page!
    if (mounted) {
      _finishOnboarding();
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final currentUser = AuthService.getCurrentUser();

      if (currentUser != null && currentUser.isAnonymous) {
        await AuthService.linkGoogleAccount();
        debugPrint("Anonymous account linked to Google successfully.");
      } else {
        await AuthService.signInWithGoogle();
        debugPrint("Performed a fresh Google Sign-In.");
      }

      if (!mounted) return;

      // Proceed to subscription
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubscriptionPage(onFinished: () => Navigator.pop(context)),
        ),
      );

      // ✅ Finish onboarding after subscription
      if (mounted) {
        _finishOnboarding();
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
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