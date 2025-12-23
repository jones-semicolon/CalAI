import 'package:flutter/material.dart';
import 'progress_cards.dart';
import 'progress_line_graph.dart';
import 'progress_photo.dart';
import 'progress_bar_graph.dart';
import 'progress_bmi_card.dart';

enum Sex { male, female }

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
    {"weight": 58.5, "date": DateTime(2025, 12, 19)},
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
        .where((e) => now.difference(e['date'] as DateTime).inDays <= days)
        .toList();
  }

  // barGraph data sample
  final List<Map<String, dynamic>> calorieLogs = [
    // ---------------- WEEK 1 (3 weeks ago) ----------------
    {
      "date": DateTime(2025, 11, 24), // Mon
      "calories": 1800,
      "protein": 120,
      "carbs": 220,
      "fats": 70,
    },
    {
      "date": DateTime(2025, 11, 25), // Tue
      "calories": 1950,
      "protein": 140,
      "carbs": 240,
      "fats": 75,
    },
    {
      "date": DateTime(2025, 11, 27), // Thu
      "calories": 1600,
      "protein": 110,
      "carbs": 200,
      "fats": 65,
    },
    {
      "date": DateTime(2025, 11, 29), // Sat
      "calories": 2100,
      "protein": 150,
      "carbs": 260,
      "fats": 80,
    },

    // ---------------- WEEK 2 (2 weeks ago) ----------------
    {
      "date": DateTime(2025, 12, 1), // Mon
      "calories": 2000,
      "protein": 140,
      "carbs": 250,
      "fats": 80,
    },
    {
      "date": DateTime(2025, 12, 2), // Tue
      "calories": 600,
      "protein": 60,
      "carbs": 80,
      "fats": 20,
    },
    {
      "date": DateTime(2025, 12, 3), // Wed
      "calories": 1356,
      "protein": 120,
      "carbs": 180,
      "fats": 45,
    },
    {
      "date": DateTime(2025, 12, 4), // Thu
      "calories": 1000,
      "protein": 90,
      "carbs": 130,
      "fats": 35,
    },

    // ---------------- WEEK 3 (last week) ----------------
    {
      "date": DateTime(2025, 12, 8), // Mon
      "calories": 520,
      "protein": 50,
      "carbs": 70,
      "fats": 15,
    },
    {
      "date": DateTime(2025, 12, 9), // Tue
      "calories": 610,
      "protein": 60,
      "carbs": 80,
      "fats": 20,
    },
    {
      "date": DateTime(2025, 12, 10), // Wed
      "calories": 480,
      "protein": 45,
      "carbs": 60,
      "fats": 15,
    },
    {
      "date": DateTime(2025, 12, 11), // Thu
      "calories": 550,
      "protein": 55,
      "carbs": 75,
      "fats": 18,
    },
    {
      "date": DateTime(2025, 12, 13), // Sat
      "calories": 900,
      "protein": 80,
      "carbs": 120,
      "fats": 30,
    },

    // ---------------- WEEK 4 (this week) ----------------
    {
      "date": DateTime(2025, 12, 16), // Tue
      "calories": 1800,
      "protein": 130,
      "carbs": 210,
      "fats": 70,
    },
    {
      "date": DateTime(2025, 12, 21), // Wed
      "calories": 1600,
      "protein": 120,
      "carbs": 200,
      "fats": 60,
    },
    {
      "date": DateTime(2025, 12, 22), // Thu
      "calories": 1900,
      "protein": 145,
      "carbs": 230,
      "fats": 75,
    },
  ];

  final double caloriesIntakePerDay = 1356; // calories intake a day data

  //Bmi Data
  final double bmi = 21.72;
  final int age = 25;
  final Sex sex = Sex.male;

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
          const SizedBox(height: 25),
          //Progress Photo
          ProgressPhoto(),

          const SizedBox(height: 25),

          ProgressBarGraph(
            calorieLogs: calorieLogs,
            caloriesIntakePerDay: caloriesIntakePerDay,
          ),

          const SizedBox(height: 25),
          ProgressBmiCard(bmi: bmi, age: age, sex: sex),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
