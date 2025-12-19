import 'package:flutter/material.dart';
import 'progress_cards.dart';
import 'progress_graph.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

enum TimeRange { days90, months6, year1, all }

class _ProgressPageState extends State<ProgressPage> {
  TimeRange selectedRange = TimeRange.days90;

  final double goalWeight = 57.3;

  final List<Map<String, dynamic>> weightLogs = [
    {"weight": 71.0, "date": DateTime(2025, 12, 1)},
    {"weight": 70.5, "date": DateTime(2025, 12, 2)},
    {"weight": 69.5, "date": DateTime(2025, 12, 5)},
    {"weight": 69.0, "date": DateTime(2025, 12, 6)},
    {"weight": 67.0, "date": DateTime(2025, 12, 11)},
    {"weight": 65.0, "date": DateTime(2025, 12, 17)},
    {"weight": 64.8, "date": DateTime(2025, 12, 18)},
    {"weight": 64.5, "date": DateTime(2025, 12, 19)},
  ];

  double get startedWeight => weightLogs.first['weight'];
  double get currentWeight => weightLogs.last['weight'];

  double goalProgressPercent() {
    final total = startedWeight - goalWeight;
    final current = startedWeight - currentWeight;
    if (total <= 0) return 0;
    return ((current / total) * 100).clamp(0, 100);
  }

  List<Map<String, dynamic>> get filteredLogs {
    if (selectedRange == TimeRange.all) return weightLogs;

    final now = weightLogs.last['date'] as DateTime;
    final days = switch (selectedRange) {
      TimeRange.days90 => 90,
      TimeRange.months6 => 180,
      TimeRange.year1 => 365,
      TimeRange.all => 0,
    };

    return weightLogs
        .where((e) =>
            now.difference(e['date'] as DateTime).inDays <= days)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: WeightCard(
                  currentWeight: currentWeight,
                  goalWeight: goalWeight,
                  progressPercent: goalProgressPercent(),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: StreakCard(
                  dayStreak: [true, true, false, true, true, true, true],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ProgressGraph(
            selectedRange: selectedRange,
            onRangeChanged: (r) => setState(() => selectedRange = r),
            logs: filteredLogs,
            startedWeight: startedWeight,
            goalWeight: goalWeight,
            progressPercent: goalProgressPercent(),
          ),
        ],
      ),
    );
  }
}
