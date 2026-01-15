import 'package:calai/pages/progress/widgets/progress_bar_graph.dart';
import 'package:calai/pages/progress/widgets/progress_bmi_card.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/global_data.dart';
import 'progress_data_provider.dart';

import 'widgets/progress_cards.dart';
import 'widgets/progress_line_graph.dart';
import 'widgets/progress_photo.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  TimeRange _selectedRange = TimeRange.days90;

  @override
  Widget build(BuildContext context) {
    final globalAsync = ref.watch(globalDataProvider);

    List<bool> _buildWeekStreak(Set<String> progressDays) {
      final now = DateTime.now();
      
      String _toDateId(DateTime date) {
        final y = date.year.toString().padLeft(4, '0');
        final m = date.month.toString().padLeft(2, '0');
        final d = date.day.toString().padLeft(2, '0');
        return "$y-$m-$d";
      }

      // Sun..Sat (your UI shows S M T W T F S)
      final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

      return List.generate(7, (i) {
        final day = startOfWeek.add(Duration(days: i));
        final id = _toDateId(day); // YYYY-MM-DD
        return progressDays.contains(id);
      });
    }
    
    return globalAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
      data: (global) {
        final logs = global.weightLogs;
        final goalWeight = global.goalWeight;

        if (logs.isEmpty) {
          return const Center(child: Text("No progress logs yet."));
        }

        final provider = ProgressPageDataProvider();

        final filteredLogs = provider.getFilteredLogs(logs, _selectedRange);

        final startedWeight = provider.startedWeight(logs);
        final currentWeight = provider.currentWeight(logs);

        final progressPercent = provider.goalProgressPercent(
          logs: logs,
          goalWeight: goalWeight,
        );
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: WeightCard(
                      currentWeight: currentWeight,
                      goalWeight: goalWeight,
                      progressPercent: progressPercent,
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
              const SizedBox(height: 25),
              ProgressGraph(
                selectedRange: _selectedRange,
                onRangeChanged: (r) => setState(() => _selectedRange = r),
                logs: filteredLogs,
                startedWeight: startedWeight,
                goalWeight: goalWeight,
                progressPercent: progressPercent,
              ),
              const SizedBox(height: 25),
              const ProgressPhoto(),
              const SizedBox(height: 25),
              ProgressBarGraph(
                calorieLogs: global.calorieLogs,
                caloriesIntakePerDay: global.calorieGoal,
              ),
              const SizedBox(height: 25),
              const ProgressBmiCard(),
              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }
}