import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/calibration_result/dashboard_widget.dart';
import '../onboarding_widgets/calibration_result/app_constants.dart';
import '../../data/macro_data.dart'; 

class OnboardingStep18 extends ConsumerWidget {
  final VoidCallback nextPage;

  const OnboardingStep18({
    super.key,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalData = ref.watch(goalsProvider);

    return SafeArea(
      child: goalData.when(
        loading: () => const Center(
          child: Text('Loading recommendations...'),
        ),
        error: (error, _) => Center(
          child: Text(
            'Failed to load recommendations',
            style: AppTextStyles.title.copyWith(color: Colors.red),
          ),
        ),
        data: (goals) {
          final macros = [
            MacroData(
              title: 'Calories',
              value: '${goals.calories}',
              progress: 0.5,
              color: AppColors.calories(context),
              icon: Icons.local_fire_department,
            ),
            MacroData(
              title: 'Carbs',
              value: '${goals.nutrients.carbs}g',
              progress: 0.5,
              color: AppColors.carbs,
              icon: Icons.rice_bowl,
            ),
            MacroData(
              title: 'Protein',
              value: '${goals.nutrients.protein}g',
              progress: 0.5,
              color: AppColors.protein,
              icon: Icons.fitness_center,
            ),
            MacroData(
              title: 'Fats',
              value: '${goals.nutrients.fat}g',
              progress: 0.5,
              color: AppColors.fats,
              icon: Icons.opacity,
            ),
          ];

          return Column(
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
                          debugPrint('Health score tapped');
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
                  onNext: nextPage,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
