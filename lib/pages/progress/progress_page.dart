import 'package:calai/pages/progress/screens/bmi_info_view.dart';
import 'package:calai/providers/progress_data_provider.dart';
import 'package:calai/pages/progress/widgets/progress_bar_graph.dart';
import 'package:calai/pages/progress/widgets/progress_bmi_card.dart';
import 'package:calai/pages/progress/widgets/progress_line_graph.dart';
import 'package:calai/pages/progress/widgets/progress_photo.dart';
import 'package:calai/pages/progress/widgets/streak_card.dart';
import 'package:calai/pages/progress/widgets/weight_card.dart';
import 'package:calai/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_sizes.dart';
import '../../providers/global_provider.dart';
import '../shell/widgets/widget_app_bar.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  TimeRange _selectedRange = TimeRange.days90;

  // Business Logic moved to a helper for cleaner build method
  List<bool> _buildWeekStreak(Set<String> progressDays) {
    final daysOrder = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    return List.generate(7, (i) => progressDays.contains(daysOrder[i]));
  }

  @override
  Widget build(BuildContext context) {
    final globalAsync = ref.watch(globalDataProvider);

    return CustomScrollView(
      slivers: [
        const WidgetTreeAppBar(),
        globalAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CupertinoActivityIndicator(radius: 15)),
          ),
          error: (e, _) => SliverFillRemaining(
            child: Center(child: Text("Unable to load progress: $e")),
          ),
          data: (global) {
            final provider = ProgressPageDataProvider();
            final unitSystem = ref.read(userProvider).settings.measurementUnit;

            final weightLogs = global.weightLogs;
            final double goalWeightMetric = global.todayGoal.weightGoal;

            final filteredWeightLogs = provider.getFilteredLogs(weightLogs, _selectedRange);
            final startedWeight = provider.startedWeight(weightLogs);
            final currentWeight = provider.currentWeight(weightLogs);
            final progressPercent = provider.goalProgressPercent(
              logs: weightLogs,
              goalWeight: goalWeightMetric,
            );

            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  children: [
                    // --- TOP CARDS ---
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: WeightCard(
                              currentWeight: currentWeight,
                              goalWeight: goalWeightMetric,
                              progressPercent: progressPercent,
                              unitSystem: unitSystem,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StreakCard(
                              dayStreak: _buildWeekStreak(global.progressDays),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- WEIGHT GRAPH (Line) ---
                    ProgressGraph(
                      selectedRange: _selectedRange,
                      onRangeChanged: (r) => setState(() => _selectedRange = r),
                      logs: filteredWeightLogs,
                      startedWeight: startedWeight,
                      goalWeight: goalWeightMetric,
                      progressPercent: progressPercent,
                      unitSystem: unitSystem
                    ),

                    const SizedBox(height: 25),
                    const ProgressPhoto(),
                    const SizedBox(height: 25),

                    // --- NUTRITION GRAPH (Bar) ---
                    ProgressBarGraph(
                      dailyNutrition: global.dailyNutrition,
                      caloriesIntakePerDay: global.todayGoal.calories.toDouble(),
                    ),

                    const SizedBox(height: 25),
                    ProgressBmiCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BmiInfoView()))),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}