import 'package:calai/data/global_data.dart';
import 'package:calai/data/health_data.dart';
import 'package:calai/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/calibration_result/dashboard_widget.dart';
import '../onboarding_widgets/calibration_result/app_constants.dart';

class OnboardingStep18 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep18({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep18> createState() => OnboardingStep18State();
}

class OnboardingStep18State extends ConsumerState<OnboardingStep18> {
  bool _started = false;
  bool _loading = true;
  String? _error;

  Future<void> startComputation() async {
    if (_started) return;
    _started = true;
    debugPrint("starting");

    try {
      final global = ref.read(globalDataProvider.notifier);
      await global.updateProfile();
      await global.fetchGoals();
      await global.ensureDailyLogExists();

      if (mounted) setState(() => _loading = false);
      debugPrint("loaded");
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = "Failed to load recommendations";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final health = ref.watch(healthDataProvider);

    if (_loading) {
      return const Center(child: Text("Loading recommendations..."));
    }

    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    // render dashboard...
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: DailyRecommendationDashboard(
                  macros: [
                    MacroData(
                      title: 'Calories',
                      value: '${health.calorieGoal}',
                      progress: 1,
                      color: AppColors.calories(context),
                      icon: Icons.local_fire_department,
                    ),
                    MacroData(
                      title: 'Carbs',
                      value: '${health.carbsGoal}g',
                      progress: 1,
                      color: AppColors.carbs,
                      icon: Icons.rice_bowl,
                    ),
                    MacroData(
                      title: 'Protein',
                      value: '${health.proteinGoal}g',
                      progress: 1,
                      color: AppColors.protein,
                      icon: Icons.fitness_center,
                    ),
                    MacroData(
                      title: 'Fats',
                      value: '${health.fatsGoal}g',
                      progress: 1,
                      color: AppColors.fats,
                      icon: Icons.opacity,
                    ),
                  ],
                  healthScoreProgress: 0.7,
                  healthScore: 7,
                  onHealthScoreTap: () {},
                ),
              ),
            ],
          ),
        ),
        ContinueButton(enabled: true, onNext: widget.nextPage),
      ],
    );
  }
}