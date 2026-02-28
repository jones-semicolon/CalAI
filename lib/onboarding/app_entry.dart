import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  // ✅ 1. Store the initial route calculation in a variable
  late Future<Widget> _initialRoute;

  @override
  void initState() {
    super.initState();
    // ✅ 2. Run the check EXACTLY ONCE when the app boots up
    _initialRoute = _determineRoute();
  }

  Future<Widget> _determineRoute() async {
    final user = FirebaseAuth.instance.currentUser;

    // If no one is logged in, start onboarding from the beginning
    if (user == null) {
      return const OnboardingPage(startIndex: 0);
    }

    final prefs = await SharedPreferences.getInstance();
    bool completed = prefs.getBool('onboarding_completed') ?? false;

    if (!completed) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final data = doc.data();
        final isDone = data?['profile']?['onboardingCompleted'] == true;

        if (isDone) {
          completed = true;
          await prefs.setBool('onboarding_completed', true);
        }
      } catch (e) {
        debugPrint("Error checking onboarding: $e");
      }
    }

    return completed ? const WidgetTree() : const OnboardingPage(startIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialRoute,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CupertinoActivityIndicator(radius: 15)),
          );
        }

        if (snapshot.hasData) {
          return snapshot.data!;
        }

        // Safe fallback
        return const OnboardingPage(startIndex: 0);
      },
    );
  }
}