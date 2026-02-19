import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    // 1. Get current Firebase user
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();

      // 2. Check local flag first (fastest)
      _onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

      // 3. If local flag is false, check Firestore (Safety for returning users)
      if (!_onboardingCompleted) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();

        if (doc.exists) {
          final data = doc.data();

          // ✅ FIX: Check the correct nested field path
          // In your Service, you save goals under 'goal': {'dailyGoals': ...}
          final hasGoals = data?['goal']?['dailyGoals'] != null;

          if (hasGoals) {
            _onboardingCompleted = true;
            await prefs.setBool('onboarding_completed', true);
          }
        }
      }
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user == null) return const OnboardingPage(startIndex: 0);

    return _onboardingCompleted
        ? const WidgetTree()
        : const OnboardingPage(startIndex: 1);
  }
}