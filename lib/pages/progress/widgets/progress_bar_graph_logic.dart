import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Defines the time range options for the progress bar graph.
enum WeekRange { thisWeek, lastWeek, twoWeeksAgo, threeWeeksAgo }

/// A developer-friendly class to encapsulate all the business logic for the
/// ProgressBarGraph widget.
///
/// This class takes the raw log data and the selected time range, and provides
/// clean, ready-to-use outputs for the UI, such as filtered logs, total calories,
/// and the data groups required by the chart library.
class ProgressBarGraphLogic {
  final List<Map<String, dynamic>> allLogs;
  final WeekRange selectedRange;

  ProgressBarGraphLogic({required this.allLogs, required this.selectedRange});

  // --- Core Data Processing --- //

  /// Filters the raw logs to include only the data for the selected week.
  List<Map<String, dynamic>> get filteredLogs {
    final now = DateTime.now();
    // Use Sunday as the start of the week (weekday % 7).
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

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

    return allLogs.where((e) {
      final d = e['date'] as DateTime;
      return !d.isBefore(start) && d.isBefore(end);
    }).toList();
  }

  // --- Computed Properties for the UI --- //

  /// Calculates the total calories from the filtered logs.
  double get totalCalories =>
      filteredLogs.fold(0.0, (s, e) => s + (e['calories'] as num).toDouble());

  /// Calculates the percentage of the weekly calorie target that has been met.
  double percentageOfTarget(double dailyGoal) {
    final weeklyTarget = dailyGoal * 7;
    if (weeklyTarget == 0) return 0;
    return (totalCalories / weeklyTarget) * 100;
  }

  /// Generates the list of [BarChartGroupData] needed to render the bar chart.
  List<BarChartGroupData> getBarGroups() {
    return List.generate(7, (i) {
      final log = _getLogForDay(i);
      if (log.isEmpty) {
        return BarChartGroupData(x: i, barRods: []);
      }

      final double calories = (log['calories'] as num).toDouble();
      final double protein = (log['protein'] as num).toDouble();
      final double carbs = (log['carbs'] as num).toDouble();
      final double fats = (log['fats'] as num).toDouble();
      final double macroTotal = protein + carbs + fats;

      if (macroTotal == 0) {
        return BarChartGroupData(x: i, barRods: []);
      }

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

  /// Finds the log entry for a specific day of the week index (0=Sun, 1=Mon, etc.).
  Map<String, dynamic> _getLogForDay(int dayIndex) {
    return filteredLogs.firstWhere(
      (e) => ((e['date'] as DateTime).weekday % 7) == dayIndex,
      orElse: () => {},
    );
  }

  /// Gets the protein for a specific day index, used by the chart's tooltip.
  double getDayProtein(int dayIndex) {
    final log = _getLogForDay(dayIndex);
    return log.isEmpty ? 0 : (log['protein'] as num).toDouble();
  }

  /// Gets the carbs for a specific day index.
  double getDayCarbs(int dayIndex) {
    final log = _getLogForDay(dayIndex);
    return log.isEmpty ? 0 : (log['carbs'] as num).toDouble();
  }

  /// Gets the fats for a specific day index.
  double getDayFats(int dayIndex) {
    final log = _getLogForDay(dayIndex);
    return log.isEmpty ? 0 : (log['fats'] as num).toDouble();
  }
}
