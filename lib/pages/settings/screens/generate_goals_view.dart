import 'package:calai/onboarding/steps_pages/step_2.dart';
import 'package:calai/services/calai_firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../enums/user_enums.dart';
import '../../../onboarding/onboarding_widgets/onboarding_appbar.dart';
import '../../../onboarding/steps_pages/step_6.dart';
import '../../../onboarding/steps_pages/step_8.dart';
import '../../../onboarding/steps_pages/step_9.1.dart';
import '../../../onboarding/steps_pages/step_9.3.dart';
import '../../../providers/user_provider.dart';

class GenerateGoalsView extends ConsumerStatefulWidget {
  final int startIndex;

  const GenerateGoalsView({super.key, this.startIndex = 0});

  @override
  ConsumerState<GenerateGoalsView> createState() => _GenerateGoalsViewState();
}

class _GenerateGoalsViewState extends ConsumerState<GenerateGoalsView> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isGenerating = false;

  // ✅ Helper to get the current goal safely
  Goal get _currentGoal => ref.read(userProvider).goal.type ?? Goal.maintain;

  List<Widget> _getPages(Goal goal) {
    return [
      OnboardingStep2(nextPage: _nextPage),
      OnboardingStep6(nextPage: _nextPage),
      OnboardingStep8(nextPage: _nextPage),
      if (goal != Goal.maintain) ...[WeightPickerPage(nextPage: _nextPage)],
      ProgressSpeed(nextPage: _onDone),
    ];
  }

  void _nextPage() async {
    final pages = _getPages(_currentGoal);

    if (_currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _onDone() async {
    if (_isGenerating) return; // Prevent multiple clicks

    setState(() => _isGenerating = true);

    try {
      // 1. Await the goal generation/fetching
      await ref
          .read(userProvider.notifier)
          .refreshNutritionGoals();

      // 2. Only pop after the data is successfully saved
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isGenerating = false);
      // Show an error snackbar if something goes wrong
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to generate goals: $e")));
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
    final goal =
        ref.watch(userProvider.select((u) => u.goal.type)) ?? Goal.maintain;
    final pages = _getPages(goal);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          // ✅ Wrap in Stack to show overlay
          children: [
            Column(
              children: [
                OnboardingAppBar(
                  currentIndex: (_currentIndex - 1).clamp(0, pages.length - 2),
                  totalPages: pages.length - 1,
                  onBack: _isGenerating
                      ? () {}
                      : () {
                          // Disable back while loading
                          if (_currentIndex > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    children: pages,
                  ),
                ),
              ],
            ),

            // ✅ The Loading Overlay
            if (_isGenerating)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoActivityIndicator(radius: 15),
                      SizedBox(height: 20),
                      Text(
                        "Calculating your custom goals...",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
