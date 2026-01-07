import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import 'widgets/progress_cards.dart';
import 'widgets/progress_line_graph.dart';
import 'widgets/progress_photo.dart';
import 'widgets/progress_bar_graph.dart';
import 'widgets/progress_bmi_card.dart';
import 'progress_data_provider.dart'; // Import the new data provider

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // --- STATE --- //

  /// Encapsulates all mock data and business logic for this page.
  /// In a real app, this might be a ViewModel or be provided by a state management library.
  final _dataProvider = ProgressPageDataProvider();

  /// The currently selected time range for filtering the graphs.
  TimeRange _selectedRange = TimeRange.days90;

  // --- BUILD METHOD --- //

  @override
  Widget build(BuildContext context) {
    // Get the filtered logs based on the current UI state.
    final filteredLogs = _dataProvider.getFilteredLogs(_selectedRange);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: WeightCard(
                  currentWeight: _dataProvider.currentWeight,
                  goalWeight: _dataProvider.goalWeight,
                  progressPercent: _dataProvider.goalProgressPercent(),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: StreakCard(
                  // Note: Streak data is hardcoded here and could also be moved to the provider.
                  dayStreak: [true, true, false, true, true, true, true],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ProgressGraph(
            selectedRange: _selectedRange,
            onRangeChanged: (r) => setState(() => _selectedRange = r as TimeRange),
            logs: filteredLogs,
            startedWeight: _dataProvider.startedWeight,
            goalWeight: _dataProvider.goalWeight,
            progressPercent: _dataProvider.goalProgressPercent(),
          ),
          const SizedBox(height: 25),
          ProgressPhoto(),
          const SizedBox(height: 25),
          ProgressBarGraph(
            calorieLogs: _dataProvider.calorieLogs,
            caloriesIntakePerDay: _dataProvider.caloriesIntakePerDay,
          ),
          const SizedBox(height: 25),
          ProgressBmiCard(
            bmi: _dataProvider.bmi,
            age: _dataProvider.age,
            sex: _dataProvider.sex,
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
