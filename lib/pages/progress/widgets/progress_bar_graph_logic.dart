import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/nutrition_model.dart';

/// Defines the time range options for the progress bar graph.
enum WeekRange { thisWeek, lastWeek, twoWeeksAgo, threeWeeksAgo }

class ProgressBarGraphLogic {
  // ✅ UPDATED: Use your new DailyNutrition model
  final List<DailyNutrition> allLogs;
  final WeekRange selectedRange;

  ProgressBarGraphLogic({required this.allLogs, required this.selectedRange});

  // --- Core Data Processing --- //

  List<DailyNutrition> get filteredLogs {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);

    // Calculate start of current week (Sunday as 0)
    final startOfWeek = todayMidnight.subtract(Duration(days: todayMidnight.weekday % 7));

    DateTime start;
    DateTime end;

    switch (selectedRange) {
      case WeekRange.thisWeek:
        start = startOfWeek;
        end = startOfWeek.add(const Duration(days: 7));
        break;
      case WeekRange.lastWeek:
        start = startOfWeek.subtract(const Duration(days: 7));
        end = startOfWeek;
        break;
      case WeekRange.twoWeeksAgo:
        start = startOfWeek.subtract(const Duration(days: 14));
        end = startOfWeek.subtract(const Duration(days: 7));
        break;
      case WeekRange.threeWeeksAgo:
        start = startOfWeek.subtract(const Duration(days: 21));
        end = startOfWeek.subtract(const Duration(days: 14));
        break;
    }

    // 1. Filter by date range
    final rangeFiltered = allLogs.where((e) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      return (d.isAfter(start) || d.isAtSameMomentAs(start)) && d.isBefore(end);
    }).toList();

    // 2. DEDUPLICATION: Ensure one entry per day
    final Map<String, DailyNutrition> dailyMap = {};
    for (var log in rangeFiltered) {
      final String dateKey = "${log.date.year}-${log.date.month}-${log.date.day}";
      dailyMap[dateKey] = log;
    }

    return dailyMap.values.toList();
  }

  // --- Computed Properties for the UI --- //

  double get totalCalories =>
      filteredLogs.fold(0.0, (s, e) => s + e.kc.toDouble());

  double percentageOfTarget(double dailyGoal) {
    final weeklyTarget = dailyGoal * 7;
    if (weeklyTarget == 0) return 0;
    return (totalCalories / weeklyTarget) * 100;
  }

  List<BarChartGroupData> getBarGroups() {
    return List.generate(7, (i) {
      final log = _getLogForDay(i);

      final double calories = log?.kc.toDouble() ?? 0.0;
      final double protein = log?.p.toDouble() ?? 0.0;
      final double carbs = log?.c.toDouble() ?? 0.0;
      final double fats = log?.f.toDouble() ?? 0.0;

      final double macroTotal = protein + carbs + fats;

      if (calories == 0 || macroTotal == 0) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: 0, width: 20, color: Colors.transparent)
          ],
        );
      }

      // Proportional macro stacking relative to total calories
      final double fatsHeight = calories * (fats / macroTotal);
      final double carbsHeight = calories * (carbs / macroTotal);
      final double proteinHeight = calories * (protein / macroTotal);

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: calories,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            rodStackItems: [
              BarChartRodStackItem(0, fatsHeight, const Color.fromARGB(255, 105, 152, 222)),
              BarChartRodStackItem(fatsHeight, fatsHeight + carbsHeight, const Color.fromARGB(255, 222, 154, 105)),
              BarChartRodStackItem(fatsHeight + carbsHeight, fatsHeight + carbsHeight + proteinHeight, const Color.fromARGB(255, 221, 105, 105)),
            ],
          ),
        ],
      );
    });
  }

  // --- Private Helpers --- //

  DailyNutrition? _getLogForDay(int weekdayIndex) {
    try {
      return filteredLogs.firstWhere(
            (log) => log.date.weekday % 7 == weekdayIndex,
        orElse: () => throw 'not_found',
      );
    } catch (_) {
      return null;
    }
  }

  double getDayProtein(int dayIndex) => _getLogForDay(dayIndex)?.p.toDouble() ?? 0.0;
  double getDayCarbs(int dayIndex) => _getLogForDay(dayIndex)?.c.toDouble() ?? 0.0;
  double getDayFats(int dayIndex) => _getLogForDay(dayIndex)?.f.toDouble() ?? 0.0;
}