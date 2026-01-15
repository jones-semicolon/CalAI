import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calai/data/user_data.dart';

final globalDataProvider = ChangeNotifierProvider<GlobalData>((ref) {
  return GlobalData(ref);
});

class GlobalData extends ChangeNotifier {
  final Ref ref;
  GlobalData(this.ref);

  // --- STATE VARIABLES ---
  bool _isFetching = false;
  bool get isFetching => _isFetching;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Goals (Locally cached state)
  int calorieGoal = 0;
  int proteinGoal = 0;
  int carbsGoal = 0;
  int fatsGoal = 0;
  int fiberGoal = 0;
  int sugarGoal = 0;
  int sodiumGoal = 0;

  // Daily Summary (Calculated from /dailyLogs/YYYY-MM-DD)
  int dailyIntake = 0;
  int dailyWater = 0;
  int dailyBurned = 0;
  double dailyProtein = 0;
  double dailyCarbs = 0;
  double dailyFats = 0;

  // --- HELPERS ---
  String get _todayId => DateTime.now().toIso8601String().split('T')[0];

  DocumentReference _userDoc(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  DocumentReference _dailyLogDoc(String uid, String date) =>
      _userDoc(uid).collection('dailyLogs').doc(date);

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // --- CORE LOGIC ---

  Future<void> init() async {
    if (_isInitialized || _isFetching) return;
    _isFetching = true;
    notifyListeners();

    try {
      syncFirebaseName();
      bool hasGoals = await loadGoalsFromFirestore();

      if (!hasGoals) {
        await updateProfile();
        await fetchGoals();
      }

      // Ensure the Daily Log document exists for today with current goal snapshots
      await ensureDailyLogExists();
      await fetchDailySummary(_todayId);

      _isInitialized = true;
    } catch (e) {
      debugPrint("Initialization Error: $e");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  /// Primes today's document with a snapshot of goals to prevent historical data changes
  Future<void> ensureDailyLogExists() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final dayRef = _dailyLogDoc(uid, _todayId);
    final doc = await dayRef.get();

    if (!doc.exists) {
      await dayRef.set({
        'date': _todayId,
        // Snapshot goals
        'calorieGoal': calorieGoal,
        'proteinGoal': proteinGoal,
        'carbsGoal': carbsGoal,
        'fatsGoal': fatsGoal,
        // Init totals
        'caloriesEaten': 0,
        'caloriesBurned': 0,
        'netCalories': 0,
        'protein': 0,
        'carbs': 0,
        'fats': 0,
        'waterMl': 0,
        'steps': 0,
        'diffFromGoal': -calorieGoal,
        'onTrack': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> fetchDailySummary(String dateId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await _dailyLogDoc(uid, dateId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        dailyIntake = (data['caloriesEaten'] ?? 0).toInt();
        dailyWater = (data['waterMl'] ?? 0).toInt();
        dailyBurned = (data['caloriesBurned'] ?? 0).toInt();
        dailyProtein = (data['protein'] ?? 0).toDouble();
        dailyCarbs = (data['carbs'] ?? 0).toDouble();
        dailyFats = (data['fats'] ?? 0).toDouble();
      } else {
        dailyIntake = 0; dailyWater = 0; dailyBurned = 0;
        dailyProtein = 0; dailyCarbs = 0; dailyFats = 0;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Summary Load Error: $e");
    }
  }

  Future<void> logFoodEntry({
    required String name,
    required int calories,
    required double p, required double c, required double f,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await ensureDailyLogExists();

    final batch = FirebaseFirestore.instance.batch();
    final dayRef = _dailyLogDoc(uid, _todayId);
    final entryRef = dayRef.collection('entries').doc();

    batch.set(entryRef, {
      'name': name,
      'calories': calories,
      'macros': {'p': p, 'c': c, 'f': f},
      'timestamp': FieldValue.serverTimestamp(),
    });

    batch.update(dayRef, {
      'caloriesEaten': FieldValue.increment(calories),
      'netCalories': FieldValue.increment(calories),
      'protein': FieldValue.increment(p),
      'carbs': FieldValue.increment(c),
      'fats': FieldValue.increment(f),
      'diffFromGoal': FieldValue.increment(calories),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    // Recalculate 'onTrack' status locally or via helper
    await fetchDailySummary(_todayId);
  }

  Future<void> updateWater(int amountMl) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _dailyLogDoc(uid, _todayId).set({
      'waterMl': amountMl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    dailyWater = amountMl;
    notifyListeners();
  }

  // --- AUTH & PROFILE HELPERS ---

  void syncFirebaseName() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final currentState = ref.read(userProvider);
    if (currentState.name.isNotEmpty) return;
    if (firebaseUser?.displayName != null) {
      ref.read(userProvider.notifier).setName(firebaseUser!.displayName!);
    }
  }

  Future<bool> loadGoalsFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    try {
      final doc = await _userDoc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final String? cloudName = data['name'];
        if (cloudName != null) ref.read(userProvider.notifier).setName(cloudName);

        final goalsMap = data['dailyGoals'] as Map<String, dynamic>?;
        if (goalsMap != null) {
          _updateInternalState(goalsMap);
          return true;
        }
      }
    } catch (e) {
      debugPrint("Error loading goals: $e");
    }
    return false;
  }

  Future<void> updateProfile() async {
    final user = ref.read(userProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await _userDoc(uid).set({
        "gender": user.gender.toString(),
        "height": user.height,
        "weight": user.weight,
        "birthdate": user.birthDay.toIso8601String(),
        "name": user.name,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Profile Update Error: $e');
    }
  }

  Future<void> fetchGoals() async {
    final user = ref.read(userProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final response = await http.post(
        Uri.parse('https://cal-ai-liard.vercel.app/calculate_goals'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "age": _calculateAge(user.birthDay),
          "gender": user.gender,
          "height": user.height,
          "weight": user.weight,
          "activity_level": user.workOutPerWeek,
          "goal": user.goal,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiData = jsonDecode(response.body)['data'];
        final nutrients = apiData['nutrients'];
        final micro = nutrients?['micronutrients'];

        final Map<String, dynamic> dailyGoals = {
          "calorieGoal": (apiData['calories'] ?? 0).toInt(),
          "proteinGoal": (nutrients?['protein_g'] ?? 0).toInt(),
          "carbsGoal": (nutrients?['carbs_g'] ?? 0).toInt(),
          "fatsGoal": (nutrients?['fat_g'] ?? 0).toInt(),
          "microGoal": {
            "fiberGoal": (micro?['fiber_g'] ?? 0).toInt(),
            "sugarGoal": (micro?['sugar_g'] ?? 0).toInt(),
            "sodiumGoal": (micro?['sodium_mg'] ?? 0).toInt(),
          }
        };

        _updateInternalState(dailyGoals);
        await _userDoc(uid).set({"dailyGoals": dailyGoals}, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('API Fetch Error: $e');
    }
  }

  void _updateInternalState(Map<String, dynamic> data) {
    calorieGoal = data['calorieGoal'] ?? 0;
    proteinGoal = data['proteinGoal'] ?? 0;
    carbsGoal = data['carbsGoal'] ?? 0;
    fatsGoal = data['fatsGoal'] ?? 0;

    final micro = data['microGoal'] as Map<String, dynamic>?;
    if (micro != null) {
      fiberGoal = micro['fiberGoal'] ?? 0;
      sugarGoal = micro['sugarGoal'] ?? 0;
      sodiumGoal = micro['sodiumGoal'] ?? 0;
    }
    notifyListeners();
  }
}