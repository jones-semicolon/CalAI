import 'package:calai/onboarding/onboarding_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:calai/pages/auth/auth-page.dart';
// Make sure this import points to where you saved the GoogleSignInService class
import 'package:calai/pages/auth/auth.dart';
import '../../pages/shell/widget_tree.dart';
import 'sign_in_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 100),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Pre-initialize Google Sign-In (Optional but good for performance)
    AuthService.initSignIn();

    _controller.forward();
  }

  Future<void> _close() async {
    await _controller.reverse();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _handleGoogleSignIn() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await AuthService.signInWithGoogle();

      if (!mounted) return;

      if (userCredential != null && userCredential.user != null) {
        // 1. Check Firestore to see if this user already has a profile
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        final bool hasCompletedOnboarding =
            userDoc.exists && userDoc.data()?['goal'] != null && userDoc.data()?['goal']['dailyGoals'] != null;

        if (!mounted) return;
        await _controller.reverse();

        // 2. Navigate based on their history
        if (hasCompletedOnboarding) {
          // RETURNING USER: Go straight to the app
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WidgetTree()),
                (route) => false,
          );
        } else {
          // NEW USER: Go to onboarding steps
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const OnboardingPage(startIndex: 1),
            ),
          );
        }
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sheetHeight = size.height * 0.5;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: _close,
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                top: false,
                child: Container(
                  constraints: BoxConstraints(maxHeight: sheetHeight),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            const Spacer(),
                            Text(
                              'Sign in',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _close,
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: Column(
                            children: [
                              SignInButton(
                                icon: FontAwesomeIcons.google,
                                text: 'Sign in with Google',
                                onTap: _handleGoogleSignIn,
                              ),
                              const SizedBox(height: 20),
                              SignInButton(
                                icon: Icons.email_outlined,
                                text: 'Sign in with Email',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AuthPage(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}