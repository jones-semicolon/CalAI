import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/widget_tree.dart';
import 'auth_entry/auth_entry_page.dart';
import 'onboarding_widgets/onboarding_appbar.dart';
import 'steps_pages/step_1.dart';
import 'steps_pages/step_12.dart';
import 'steps_pages/step_13.dart';
import 'steps_pages/step_14.dart';
import 'steps_pages/step_15.dart';
import 'steps_pages/step_16.dart';
import 'steps_pages/step_2.dart';
import 'steps_pages/step_3.dart';
import 'steps_pages/step_4.dart';
import 'steps_pages/step_5.dart';
import 'steps_pages/step_6.dart';
import 'steps_pages/step_7.dart';
import 'steps_pages/step_8.dart';
import 'steps_pages/step_9.dart';
import 'steps_pages/step_10.dart';
import 'steps_pages/step_11.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  
  final PageController _pageController = PageController();


  int _currentIndex = 0;

  List<Widget> get _pages => [
    AuthEntryPage(onGetStarted: _nextPage),
    OnboardingStep1(nextPage: _nextPage),
    OnboardingStep2(nextPage: _nextPage),
    OnboardingStep3(nextPage: _nextPage),
    OnboardingStep4(nextPage: _nextPage),
    OnboardingStep5(nextPage: _nextPage),
    OnboardingStep6(nextPage: _nextPage),
    OnboardingStep7(nextPage: _nextPage),
    OnboardingStep8(nextPage: _nextPage),
    OnboardingStep9(nextPage: _nextPage),
    OnboardingStep10(nextPage: _nextPage),
    OnboardingStep11(nextPage: _nextPage),
    OnboardingStep12(nextPage: _nextPage),
    OnboardingStep13(nextPage: _nextPage),
    OnboardingStep14(nextPage: _nextPage),
    OnboardingStep15(nextPage: _nextPage),
    OnboardingStep16(nextPage: _nextPage),
  ];

  void _nextPage() async {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                totalPages: _pages.length - 1,
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
                },
                children: _pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
