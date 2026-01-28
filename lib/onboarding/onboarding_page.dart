import 'package:calai/onboarding/steps_pages/step_11.dart';
import 'package:calai/onboarding/steps_pages/step_12.dart';
import 'package:calai/onboarding/steps_pages/step_13.dart';
import 'package:calai/onboarding/steps_pages/step_14.dart';
import 'package:calai/onboarding/steps_pages/step_15.dart';
import 'package:calai/onboarding/steps_pages/step_16.dart';
import 'package:calai/onboarding/steps_pages/step_17.dart';
import 'package:calai/onboarding/steps_pages/step_18.dart';
import 'package:calai/onboarding/steps_pages/step_9.1.dart';
import 'package:calai/onboarding/steps_pages/step_9.2.dart';
import 'package:calai/onboarding/steps_pages/step_9.3.dart';
import 'package:calai/onboarding/steps_pages/step_9.4.dart';
import 'package:calai/onboarding/steps_pages/step_9.5.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calai/pages/shell/widget_tree.dart';
import '../data/user_data.dart';
import 'auth_entry/auth_entry_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_widgets/onboarding_appbar.dart';
import 'steps_pages/step_1.dart';
import 'steps_pages/step_2.dart';
import 'steps_pages/step_3.dart';
import 'steps_pages/step_4.dart';
import 'steps_pages/step_5.dart';
import 'steps_pages/step_6.dart';
import 'steps_pages/step_7.dart';
import 'steps_pages/step_8.dart';
import 'steps_pages/step_9.dart';
import 'steps_pages/step_10.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  final int startIndex;

  const OnboardingPage({super.key, this.startIndex = 0});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final GlobalKey<OnboardingStep18State> _step18Key =
  GlobalKey<OnboardingStep18State>();
  late PageController _pageController = PageController();
  late int _currentIndex;

  List<Widget> _pages(Goal goal) {
    return [AuthEntryPage(onGetStarted: _nextPage),

      OnboardingStep1(nextPage: _nextPage),
      OnboardingStep2(nextPage: _nextPage),
      OnboardingStep3(nextPage: _nextPage),
      OnboardingStep4(nextPage: _nextPage),
      OnboardingStep5(nextPage: _nextPage),
      OnboardingStep6(nextPage: _nextPage),
      OnboardingStep7(nextPage: _nextPage),
      OnboardingStep8(nextPage: _nextPage),
      if (goal != Goal.maintain) WeightPickerPage(nextPage: _nextPage),
      if (goal != Goal.maintain) EncourageMessage(nextPage: _nextPage),
      if (goal != Goal.maintain) ProgressSpeed(nextPage: _nextPage),
      if (goal != Goal.maintain) Comparison(nextPage: _nextPage),
      if (goal != Goal.maintain) Demotivated(nextPage: _nextPage),
      OnboardingStep9(nextPage: _nextPage),
      OnboardingStep10(nextPage: _nextPage),
      OnboardingStep11(nextPage: _nextPage),
      OnboardingStep12(nextPage: _nextPage),
      OnboardingStep13(nextPage: _nextPage),
      OnboardingStep14(nextPage: _nextPage),
      OnboardingStep15(nextPage: _nextPage),
      OnboardingStep16(nextPage: _nextPage),
      OnboardingStep17(nextPage: _nextPage),
      OnboardingStep18(
      key: _step18Key,
      nextPage: _nextPage,
      ),
    ];
  }

  void _nextPage() async {
    final Goal goal = ref.watch(userProvider).goal;

    final List<Widget> pages = _pages(goal);

    if (_currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page: finish onboarding
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WidgetTree()),
            (route) => false, // This removes ALL previous routes
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Goal goal = ref.watch(userProvider).goal;
    final pages = _pages(goal);

    final bool isAuthPage = _currentIndex == 0;

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
                onBack: () {
                  if (_currentIndex > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),

            /// PAGES
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);

                  final goal = ref.read(userProvider).goal;
                  final pages = _pages(goal);

                  // ✅ Trigger Step 18 computation ONLY when it becomes visible
                  if (pages[index] is OnboardingStep18) {
                    _step18Key.currentState?.startComputation();
                  }
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
