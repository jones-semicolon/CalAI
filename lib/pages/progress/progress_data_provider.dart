import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Enum for defining time ranges for filtering graph data.
enum TimeRange { days90, months6, year1, all }

class ProgressPageDataProvider {
  ProgressPageDataProvider({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _dailyLogsCol(String uid) =>
      _userDoc(uid).collection('dailyLogs');

  /// Returns weight logs like:
  /// [
  ///   { "date": DateTime, "weight": double },
  /// ]
  Future<List<Map<String, dynamic>>> fetchWeightLogs({
    TimeRange range = TimeRange.days90,
  }) async {
    final uid = _uid;
    if (uid == null) return [];

    final now = DateTime.now();
    final startDate = _rangeStartDate(now, range);

    Query<Map<String, dynamic>> query = _dailyLogsCol(uid).orderBy('date');

    // ✅ Only filter if NOT all time
    if (range != TimeRange.all) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: _toDateId(startDate),
      );
    }

    final snap = await query.get();

    final logs = <Map<String, dynamic>>[];

    for (final doc in snap.docs) {
      final data = doc.data();

      final progress = data['dailyProgress'] as Map<String, dynamic>?;
      final weight = progress?['weight'];
      if (weight == null) continue;

      final dateStr = (data['date'] ?? doc.id).toString();
      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;

      logs.add({
        'date': date,
        'weight': (weight as num).toDouble(),
      });
    }

    return logs;
  }

  DateTime _rangeStartDate(DateTime now, TimeRange range) {
    switch (range) {
      case TimeRange.days90:
        return now.subtract(const Duration(days: 90));
      case TimeRange.months6:
        return DateTime(now.year, now.month - 6, now.day);
      case TimeRange.year1:
        return DateTime(now.year - 1, now.month, now.day);
      case TimeRange.all:
        return DateTime(1970);
    }
  }

  /// Converts DateTime -> "YYYY-MM-DD"
  String _toDateId(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  /// Reads goal weight from today's dailyLog:
  /// dailyGoals.weightGoal
  ///
  /// If not found today, it falls back to the latest dailyLog that has it.
  Future<double?> fetchGoalWeight() async {
    final uid = _uid;
    if (uid == null) return null;

    // Try today first
    final todayId = DateTime.now().toIso8601String().split('T').first;
    final todayDoc = await _dailyLogsCol(uid).doc(todayId).get();

    double? goal = _extractGoalWeight(todayDoc.data());
    if (goal != null) return goal;

    // Fallback: find latest log with weightGoal
    final latestSnap = await _dailyLogsCol(uid)
        .orderBy('date', descending: true)
        .limit(30)
        .get();

    for (final doc in latestSnap.docs) {
      goal = _extractGoalWeight(doc.data());
      if (goal != null) return goal;
    }

    return null;
  }

  double? _extractGoalWeight(Map<String, dynamic>? data) {
    if (data == null) return null;
    final goals = data['dailyGoals'] as Map<String, dynamic>?;
    final goalWeight = goals?['weightGoal'];
    if (goalWeight == null) return null;
    return (goalWeight as num).toDouble();
  }

  // -----------------------------
  // Business logic helpers
  // -----------------------------

  /// The user's weight when they first started logging.
  double startedWeight(List<Map<String, dynamic>> logs) {
    if (logs.isEmpty) return 0;
    return (logs.first['weight'] as num).toDouble();
  }

  /// The user's most recently logged weight.
  double currentWeight(List<Map<String, dynamic>> logs) {
    if (logs.isEmpty) return 0;
    return (logs.last['weight'] as num).toDouble();
  }

  /// Calculates the percentage of the weight loss goal that has been achieved.
  /// Returns a value between 0 and 100.
  double goalProgressPercent({
    required List<Map<String, dynamic>> logs,
    required double goalWeight,
  }) {
    if (logs.isEmpty) return 0;

    final start = startedWeight(logs);
    final current = currentWeight(logs);

    final total = start - goalWeight;
    final progressed = start - current;

    if (total <= 0) return 0;
    return ((progressed / total) * 100).clamp(0, 100);
  }

  /// Filters the weight logs based on the selected time range.
  List<Map<String, dynamic>> getFilteredLogs(
      List<Map<String, dynamic>> logs,
      TimeRange selectedRange,
      ) {
    if (logs.isEmpty) return [];
    if (selectedRange == TimeRange.all) return logs;

    final now = logs.last['date'] as DateTime;

    final days = switch (selectedRange) {
      TimeRange.days90 => 90,
      TimeRange.months6 => 180,
      TimeRange.year1 => 365,
      TimeRange.all => 0,
    };

    return logs
        .where((e) => now.difference(e['date'] as DateTime).inDays <= days)
        .toList();
  }
}
