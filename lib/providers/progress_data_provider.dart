import 'package:flutter/cupertino.dart';
import '../models/exercise_model.dart';
import '../services/calai_firestore_service.dart';

enum TimeRange { days90, months6, year1, all }

class ProgressPageDataProvider {
  // ---------------------------------------------------------------------------
  // 1. DATA COORDINATION
  // ---------------------------------------------------------------------------

  /// Orchestrates fetching logs from the service
  Future<List<WeightLog>> fetchWeightLogs(CalaiFirestoreService service) async {
    return await service.getWeightHistory();
  }

  /// Orchestrates fetching goal weight from the service
  Future<double?> fetchGoalWeight(CalaiFirestoreService service) async {
    return await service.getMasterGoalWeight();
  }

  // ---------------------------------------------------------------------------
  // 2. BUSINESS LOGIC (Pure Functions)
  // ---------------------------------------------------------------------------

  double startedWeight(List<WeightLog> logs) {
    if (logs.isEmpty) return 0;
    return logs.first.weight;
  }

  double currentWeight(List<WeightLog> logs) {
    if (logs.isEmpty) return 0;
    return logs.last.weight;
  }

  double goalProgressPercent({
    required List<WeightLog> logs,
    required double goalWeight,
  }) {
    if (logs.isEmpty || goalWeight <= 0) return 0.0;

    final double start = logs.first.weight;
    final double current = logs.last.weight;

    final double initialGap = (start - goalWeight).abs();
    if (initialGap == 0) return 100.0;

    final double currentGap = (current - goalWeight).abs();
    double progress = (initialGap - currentGap) / initialGap;

    if (progress < 0) return 0.0;
    return (progress * 100).clamp(0.0, 100.0);
  }

  // ---------------------------------------------------------------------------
  // 3. FILTERING (UI Helpers)
  // ---------------------------------------------------------------------------

  List<WeightLog> getFilteredLogs(List<WeightLog> logs, TimeRange selectedRange) {
    if (logs.isEmpty || selectedRange == TimeRange.all) return logs;

    final now = DateTime.now();
    final int daysLimit = switch (selectedRange) {
      TimeRange.days90 => 90,
      TimeRange.months6 => 180,
      TimeRange.year1 => 365,
      TimeRange.all => 0,
    };

    final cutoffDate = now.subtract(Duration(days: daysLimit));
    return logs.where((e) => e.date.isAfter(cutoffDate)).toList();
  }
}