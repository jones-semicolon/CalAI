import 'package:flutter/material.dart';
import 'progress_mock_data.dart'; // Import the new mock data file

/// Enum for biological sex, used for BMI calculations.
enum Sex { male, female }

/// Enum for defining time ranges for filtering graph data.
enum TimeRange { days90, months6, year1, all }

/// A developer-friendly data provider for the Progress Page.
///
/// This class encapsulates all the business logic for the progress page,
/// sourcing its data from the `progress_mock_data.dart` file.
class ProgressPageDataProvider {
  // --- Data Properties --- //

  // Data is now sourced from the separate mock data file.
  final List<Map<String, dynamic>> weightLogs = mockWeightLogs;
  final List<Map<String, dynamic>> calorieLogs = mockCalorieLogs;

  // Other properties remain here as they are part of the core data model.
  final double goalWeight = 57.3;
  final double caloriesIntakePerDay = 1356;
  final double bmi = 21.72;
  final int age = 25;
  final Sex sex = Sex.male;

  // --- Business Logic & Computed Properties --- //

  /// The user's weight when they first started logging.
  double get startedWeight => weightLogs.first['weight'];

  /// The user's most recently logged weight.
  double get currentWeight => weightLogs.last['weight'];

  /// Calculates the percentage of the weight loss goal that has been achieved.
  /// Returns a value between 0 and 100.
  double goalProgressPercent() {
    final total = startedWeight - goalWeight;
    final current = startedWeight - currentWeight;
    if (total <= 0) return 0;
    return ((current / total) * 100).clamp(0, 100);
  }

  /// Filters the weight logs based on the selected time range.
  List<Map<String, dynamic>> getFilteredLogs(TimeRange selectedRange) {
    if (selectedRange == TimeRange.all) return weightLogs;

    final now = weightLogs.last['date'] as DateTime;
    final days = switch (selectedRange) {
      TimeRange.days90 => 90,
      TimeRange.months6 => 180,
      TimeRange.year1 => 365,
      TimeRange.all => 0, // Should be caught by the first if-statement.
    };

    return weightLogs
        .where((e) => now.difference(e['date'] as DateTime).inDays <= days)
        .toList();
  }
}
