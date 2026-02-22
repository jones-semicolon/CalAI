import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:calai/onboarding/onboarding_page.dart';
import 'package:calai/pages/shell/widget_tree.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _loading = true;
  bool _onboardingCompleted = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ✅ WAIT for Firebase Auth restoration
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // ✅ Not logged in
        if (user == null) {
          return const OnboardingPage(startIndex: 0);
        }

        // ✅ Logged in → check onboarding
        return FutureBuilder<bool>(
          future: _checkOnboarding(user),
          builder: (context, onboardingSnap) {
            if (!onboardingSnap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final completed = onboardingSnap.data!;

            return completed
                ? const WidgetTree()
                : const OnboardingPage(startIndex: 1);
          },
        );
      },
    );
  }

  Future<bool> _checkOnboarding(User user) async {
    final prefs = await SharedPreferences.getInstance();

    bool completed =
        prefs.getBool('onboarding_completed') ?? false;

    if (!completed) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      final hasGoals = data?['goal']?['dailyGoals'] != null;

      if (hasGoals) {
        completed = true;
        await prefs.setBool('onboarding_completed', true);
      }
    }

    return completed;
  }
}