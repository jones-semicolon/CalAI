import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/push_page_route.dart';
import '../../data/macro_data.dart';

import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/calibration_result/dashboard_widget.dart';
import '../onboarding_widgets/calibration_result/app_constants.dart';
import '../onboarding_widgets/edit_goal/edit_goal_screen.dart';
import '../onboarding_widgets/health_score/screen/health_score_explanation_screen.dart';

class OnboardingStep18 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep18({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep18> createState() => _OnboardingStep18State();
}

class _OnboardingStep18State extends ConsumerState<OnboardingStep18> {
  int calories = 0;
  int carbs = 0;
  int protein = 0;
  int fats = 0;

  bool _initialized = false;

  void _initializeFromGoals(goals) {
    if (_initialized || goals == null) return;

    calories = goals.calories;
    carbs = goals.nutrients.carbs;
    protein = goals.nutrients.protein;
    fats = goals.nutrients.fat;

    _initialized = true;
  }

  Future<void> _editValue({
    required String title,
    required int initialValue,
    required Color color,
    required IconData icon,
    required ValueChanged<int> onSaved,
  }) async {
    final result = await Navigator.of(context).push<int>(
      PushPageRoute(
        page: EditGoalScreen(
          title: title,
          initialValue: initialValue,
          icon: icon,
          color: color,
        ),
      ),
    );

    if (result != null) {
      setState(() => onSaved(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalData = ref.watch(goalsProvider);

    //Read data safely
    goalData.whenOrNull(data: (goals) => _initializeFromGoals(goals));

    final macros = [
      MacroData(
        title: 'Calories',
        value: '$calories',
        progress: 0.5,
        color: AppColors.calories(context),
        icon: Icons.local_fire_department,
        onTap: () => _editValue(
          title: 'Calories',
          initialValue: calories,
          icon: Icons.local_fire_department,
          color: AppColors.calories(context),
          onSaved: (v) => calories = v,
        ),
      ),
      MacroData(
        title: 'Carbs',
        value: '${carbs}g',
        progress: 0.5,
        color: AppColors.carbs,
        icon: Icons.rice_bowl,
        onTap: () => _editValue(
          title: 'Carbs',
          initialValue: carbs,
          icon: Icons.rice_bowl,
          color: AppColors.carbs,
          onSaved: (v) => carbs = v,
        ),
      ),
      MacroData(
        title: 'Protein',
        value: '${protein}g',
        progress: 0.5,
        color: AppColors.protein,
        icon: Icons.fitness_center,
        onTap: () => _editValue(
          title: 'Protein',
          initialValue: protein,
          icon: Icons.fitness_center,
          color: AppColors.protein,
          onSaved: (v) => protein = v,
        ),
      ),
      MacroData(
        title: 'Fats',
        value: '${fats}g',
        progress: 0.5,
        color: AppColors.fats,
        icon: Icons.opacity,
        onTap: () => _editValue(
          title: 'Fats',
          initialValue: fats,
          icon: Icons.opacity,
          color: AppColors.fats,
          onSaved: (v) => fats = v,
        ),
      ),
    ];

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: DailyRecommendationDashboard(
                    macros: macros,
                    healthScoreProgress: 0.7,
                    healthScore: 7,
                    onHealthScoreTap: () {
                      Navigator.of(context).push(
                        PushPageRoute(
                          page: const HealthScoreExplanationScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: true,
              onNext: widget.nextPage,
            ), // the data edited - post to api
          ),
        ],
      ),
    );
  }
}
