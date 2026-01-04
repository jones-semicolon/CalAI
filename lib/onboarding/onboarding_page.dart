import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/widget_tree.dart';
import 'auth_entry/auth_entry_page.dart';
import 'onboarding_appbar.dart';
import 'steps_widgets/onboarding_step_1.dart';
import 'steps_widgets/onboarding_step_2.dart';
import 'steps_widgets/onboarding_step_3.dart';
import 'steps_widgets/onboarding_step_4.dart';
import 'steps_widgets/onboarding_step_5.dart';

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
    const OnboardingStep1(),
    const OnboardingStep2(),
    const OnboardingStep3(),
    const OnboardingStep4(),
    const OnboardingStep5(),
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const WidgetTree()));
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
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: _pages,
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM BUTTON (ONLY AFTER AUTH PAGE)
      bottomNavigationBar: isAuthPage
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _currentIndex == _pages.length - 1
                      ? _finishOnboarding
                      : _nextPage,
                  child: Text(
                    _currentIndex == _pages.length - 1 ? 'Finish' : 'Next',
                  ),
                ),
              ),
            ),
    );
  }
}
