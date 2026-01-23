import 'package:calai/onboarding/steps_pages/step_9.1.dart';
import 'package:calai/onboarding/steps_pages/step_9.5.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_data.dart';
import '../pages/widget_tree.dart';
import 'auth_entry/auth_entry_page.dart';
import 'onboarding_widgets/onboarding_appbar.dart';
import 'steps_pages/step_1.dart';
import 'steps_pages/step_16.dart';
import 'steps_pages/step_18.dart';
import 'steps_pages/step_2.dart';
import 'steps_pages/step_3.dart';
import 'steps_pages/step_4.dart';
import 'steps_pages/step_5.dart';
import 'steps_pages/step_6.dart';
import 'steps_pages/step_7.dart';
import 'steps_pages/step_8.dart';
import 'steps_pages/step_9.2.dart';
import 'steps_pages/step_9.3.dart';
import 'steps_pages/step_9.4.dart';
import 'steps_pages/step_9.dart';
import 'steps_pages/step_10.dart';
import 'steps_pages/step_11.dart';
import 'steps_pages/step_12.dart';
import 'steps_pages/step_13.dart';
import 'steps_pages/step_14.dart';
import 'steps_pages/step_15.dart';
import 'steps_pages/step_17.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  /// Go to the next page
  void _nextPage() async {
    final goal = ref.watch(userProvider).goal.toLowerCase();

    // Determine pages dynamically
    final List<Widget> pages = _buildPages(goal);

    if (_currentIndex < pages.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex += 1);
    } else {
      // Last page: finish onboarding
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const WidgetTree()));
    }
  }

  /// Go to the previous page
  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex -= 1);
    }
  }

  /// Build pages dynamically based on goal
  List<Widget> _buildPages(String goal) {
    return [
      AuthEntryPage(onGetStarted: _nextPage),
      OnboardingStep1(nextPage: _nextPage),
      OnboardingStep2(nextPage: _nextPage),
      OnboardingStep3(nextPage: _nextPage),
      OnboardingStep4(nextPage: _nextPage),
      OnboardingStep5(nextPage: _nextPage),
      OnboardingStep6(nextPage: _nextPage),
      OnboardingStep7(nextPage: _nextPage),
      OnboardingStep8(nextPage: _nextPage),
      if (goal != 'maintain') WeightPickerPage(nextPage: _nextPage),
      if (goal != 'maintain') EncourageMessage(nextPage: _nextPage),
      if (goal != 'maintain') ProgressSpeed(nextPage: _nextPage),
      if (goal != 'maintain') Comparison(nextPage: _nextPage),
      if (goal != 'maintain') Demotivated(nextPage: _nextPage),
      OnboardingStep9(nextPage: _nextPage),
      OnboardingStep10(nextPage: _nextPage),
      OnboardingStep11(nextPage: _nextPage),
      OnboardingStep12(nextPage: _nextPage),
      OnboardingStep13(nextPage: _nextPage),
      OnboardingStep14(nextPage: _nextPage),
      OnboardingStep15(nextPage: _nextPage),
      OnboardingStep16(nextPage: _nextPage),
      OnboardingStep17(nextPage: _nextPage),
      OnboardingStep18(nextPage: _nextPage),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goal = ref.watch(userProvider).goal.toLowerCase();
    final bool isAuthPage = _currentIndex == 0;
    final pages = _buildPages(goal);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            /// APP BAR (ONLY AFTER AUTH PAGE)
            if (!isAuthPage)
              OnboardingAppBar(
                currentIndex: _currentIndex - 1,
                totalPages: pages.length - 1,
                onBack: _previousPage,
              ),

            /// PAGES
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
