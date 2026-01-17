import 'dart:async';
import 'dart:convert';

import 'package:calai/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'global_data_state.dart';
import 'health_data.dart';

final globalDataProvider =
AsyncNotifierProvider<GlobalDataNotifier, GlobalDataState>(
  GlobalDataNotifier.new,
);

class GlobalDataNotifier extends AsyncNotifier<GlobalDataState> {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _dailyLogSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _progressLogsSub;

  // -----------------------------
  // Convenience
  // -----------------------------

  String get _todayId => DateTime.now().toIso8601String().split('T').first;
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _dailyLogsCol(String uid) =>
      _userDoc(uid).collection('dailyLogs');

  DocumentReference<Map<String, dynamic>> _dailyLogDoc(String uid, String date) =>
      _dailyLogsCol(uid).doc(date);

  @override
  FutureOr<GlobalDataState> build() {
    ref.onDispose(() {
      _dailyLogSub?.cancel();
      _progressLogsSub?.cancel();
    });

    return GlobalDataState.initial();
  }

  // -----------------------------
  // Init
  // -----------------------------

  Future<void> init() async {
    // prevent double init
    if (state.asData?.value.isInitialized == true) return;

    state = const AsyncLoading();

    try {
      _syncFirebaseNameIntoUserProvider();
      await _loadUserProfileIntoUserProvider();

      final hasGoals = await loadGoalsFromFirestore();
      if (!hasGoals) {
        await updateProfile();
        await fetchGoals();
      }

      await ensureDailyLogExists();

      // Start live listeners
      listenToDailySummary(_todayId);
      listenToProgressLogs();

      // mark initialized (do not reset other fields)
      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(current.copyWith(isInitialized: true));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // -----------------------------
  // User profile (Firestore -> userProvider)
  // -----------------------------

  Future<void> _loadUserProfileIntoUserProvider() async {
    final uid = _uid;
    if (uid == null) return;

    final doc = await _userDoc(uid).get();
    final data = doc.data();
    if (data == null) return;

    final userNotifier = ref.read(userProvider.notifier);

    // height
    final height = data['height'] as num?;
    if (height != null) {
      userNotifier.setHeight(cm: height.toDouble(), unit: HeightUnit.cm);
    }

    // weight (profile weight)
    final weight = data['weight'] as num?;
    if (weight != null) {
      userNotifier.setWeight(weight.toDouble(), WeightUnit.kg);
    }

    // birthdate
    final birthdateRaw = data['birthdate']?.toString();
    final birthdate =
    birthdateRaw == null ? null : DateTime.tryParse(birthdateRaw);
    if (birthdate != null) {
      userNotifier.update((s) => s.copyWith(birthDay: birthdate));
    }

    // gender: "male" | "female" | "other"
    final genderRaw = data['gender']?.toString().toLowerCase();
    if (genderRaw != null && genderRaw.isNotEmpty) {
      final parsed = Gender.values.firstWhere(
            (g) => g.name == genderRaw,
        orElse: () => Gender.other,
      );
      userNotifier.update((s) => s.copyWith(gender: parsed));
    }

    // name (optional)
    final nameRaw = data['name']?.toString();
    if (nameRaw != null && nameRaw.isNotEmpty) {
      userNotifier.update((s) => s.copyWith(name: nameRaw));
    }
  }

  void _syncFirebaseNameIntoUserProvider() {
    final fbUser = FirebaseAuth.instance.currentUser;
    final displayName = fbUser?.displayName;
    if (displayName == null || displayName.isEmpty) return;

    final currentName = ref.read(userProvider).name;
    if (currentName.isNotEmpty) return;

    ref.read(userProvider.notifier).setName(displayName);
  }

  // -----------------------------
  // Live listeners
  // -----------------------------

  void listenToDailySummary(String dateId) {
    final uid = _uid;
    if (uid == null) return;

    _dailyLogSub?.cancel();

    _dailyLogSub = _dailyLogDoc(uid, dateId).snapshots().listen((doc) {
      final data = doc.data();
      if (!doc.exists || data == null) return;

      _applyDailyLogToHealthState(data);

      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(current.copyWith(activeDateId: dateId));
    });
  }

  void selectDay(String dateId) {
    final current = state.asData?.value ?? GlobalDataState.initial();

    // update state so UI can highlight selected day
    state = AsyncData(current.copyWith(activeDateId: dateId));

    // start listening to the selected day (this updates HealthData too)
    listenToDailySummary(dateId);
  }

  /// Aggregates:
  /// - weightLogs (date + weight)
  /// - calorieLogs (date + calories + macros)
  /// - progressDays (Set<YYYY-MM-DD>)
  /// - goalWeight + calorieGoal
  void listenToProgressLogs() {
    final uid = _uid;
    if (uid == null) return;

    _progressLogsSub?.cancel();

    _progressLogsSub = _dailyLogsCol(uid)
        .orderBy('date')
        .snapshots()
        .listen((snapshot) {
      final weightLogs = <Map<String, dynamic>>[];
      final calorieLogs = <Map<String, dynamic>>[];
      final progressDays = <String>{};
      final overDays = <String>{};
      final dailyCalories = <String, double>{};

      double goalWeight = 0;
      double calorieGoal = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final dateId = (data['date'] ?? doc.id).toString();
        final date = DateTime.tryParse(dateId);
        if (date == null) continue;

        // ----- Progress -----
        final progress = data['dailyProgress'] as Map<String, dynamic>?;
        final hasProgress = progress != null && progress.isNotEmpty;

        if (hasProgress) progressDays.add(dateId);

        // ----- Goals -----
        final goals = data['dailyGoals'] as Map<String, dynamic>?;
        final gw = goals?['weightGoal'] as num?;
        if (gw != null) goalWeight = gw.toDouble();

        final cg = goals?['calorieGoal'] as num?;
        if (cg != null) calorieGoal = cg.toDouble();

        // ----- Weight logs (line graph) -----
        final w = progress?['weight'] as num?;
        if (w != null) {
          weightLogs.add({'date': date, 'weight': w.toDouble()});
        }

        // ----- Calories + macros (bar graph) -----
        final calories = (progress?['caloriesEaten'] as num?)?.toDouble() ?? 0;
        final protein = (progress?['protein'] as num?)?.toDouble() ?? 0;
        final carbs = (progress?['carbs'] as num?)?.toDouble() ?? 0;
        final fats = (progress?['fats'] as num?)?.toDouble() ?? 0;
        dailyCalories[dateId] = calories;

        calorieLogs.add({
          'date': date,
          'calories': calories,
          'protein': protein,
          'carbs': carbs,
          'fats': fats,
        });

        // ✅ Over progress check (red)
        if (calorieGoal > 0 && calories > calorieGoal) {
          overDays.add(dateId);
        }
      }

      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(
        current.copyWith(
          weightLogs: weightLogs,
          calorieLogs: calorieLogs,
          progressDays: progressDays,
          overDays: overDays,
          dailyCalories: dailyCalories,
          goalWeight: goalWeight,
          calorieGoal: calorieGoal,
        ),
      );
    });
  }

  // -----------------------------
  // Firestore writes
  // -----------------------------

  Future<void> updatedDailyGoals() async {
    final uid = _uid;
    if (uid == null) return;

    final health = ref.read(healthDataProvider);
    final user = ref.read(userProvider);

    await _dailyLogDoc(uid, _todayId).set(
      {
        'dailyGoals': _goalsToMap(health, user),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateDailyProgress() async {
    final uid = _uid;
    if (uid == null) return;

    final health = ref.read(healthDataProvider);
    final user = ref.read(userProvider);

    await _dailyLogDoc(uid, _todayId).set(
      {
        'dailyProgress': _progressToMap(health, user),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> ensureDailyLogExists() async {
    final uid = _uid;
    if (uid == null) return;

    final dayRef = _dailyLogDoc(uid, _todayId);
    final doc = await dayRef.get();
    if (doc.exists) return;

    final health = ref.read(healthDataProvider);
    final user = ref.read(userProvider);

    await dayRef.set(
      {
        'date': _todayId,
        'dailyProgress': _progressToMap(health, user),
        'dailyGoals': _goalsToMap(health, user),
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> logFoodEntry({
    required String name,
    required int calories,
    required double p,
    required double c,
    required double f,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final dayRef = _dailyLogDoc(uid, _todayId);
    final batch = _db.batch();

    batch.set(dayRef.collection('entries').doc(), {
      'name': name,
      'calories': calories,
      'macros': {'p': p, 'c': c, 'f': f},
      'timestamp': FieldValue.serverTimestamp(),
    });

    // merge set avoids crash if doc doesn't exist
    batch.set(
      dayRef,
      {
        'dailyProgress.caloriesEaten': FieldValue.increment(calories),
        'dailyProgress.protein': FieldValue.increment(p),
        'dailyProgress.carbs': FieldValue.increment(c),
        'dailyProgress.fats': FieldValue.increment(f),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  // -----------------------------
  // Firestore reads
  // -----------------------------

  Future<void> fetchDailySummary(String dateId) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      final doc = await _dailyLogDoc(uid, dateId).get();
      final data = doc.data();
      if (!doc.exists || data == null) return;

      _applyDailyLogToHealthState(data);

      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(current.copyWith(activeDateId: dateId));
    } catch (e) {
      debugPrint('fetchDailySummary error: $e');
    }
  }

  Future<bool> loadGoalsFromFirestore() async {
    final uid = _uid;
    if (uid == null) return false;

    final doc = await _userDoc(uid).get();
    final data = doc.data();

    final goalsMap = data?['dailyGoals'] as Map<String, dynamic>?;
    if (goalsMap == null) return false;

    _applyGoalsToHealthState(goalsMap);
    return true;
  }

  // -----------------------------
  // Profile & API
  // -----------------------------

  Future<void> updateProfile() async {
    final uid = _uid;
    if (uid == null) return;

    final user = ref.read(userProvider);

    await _userDoc(uid).set(
      {
        'gender': user.gender.value, // ✅ store enum as "male|female|other"
        'height': user.height,
        'weight': user.weight,
        'birthdate': user.birthDay.toIso8601String(),
        'name': user.name,
        'activity_level': user.workOutPerWeek.value,
        'goal': user.goal.value,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> fetchGoals() async {
    final user = ref.read(userProvider);

    try {
      final response = await http.post(
        Uri.parse('https://cal-ai-liard.vercel.app/calculate_goals'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'age': _calculateAge(user.birthDay),
          'gender': user.gender.value,
          'height': user.height,
          'weight': user.weight,
          'activity_level': user.workOutPerWeek.value,
          'goal': user.goal.value,
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) return;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final apiData = body['data'] as Map<String, dynamic>?;
      if (apiData == null) return;

      final nutrients = apiData['nutrients'] as Map<String, dynamic>?;
      final micro = nutrients?['micronutrients'] as Map<String, dynamic>?;

      final dailyGoals = <String, dynamic>{
        'calorieGoal': (apiData['calories'] ?? 0).toInt(),
        'proteinGoal': (nutrients?['protein_g'] ?? 0).toInt(),
        'carbsGoal': (nutrients?['carbs_g'] ?? 0).toInt(),
        'fatsGoal': (nutrients?['fat_g'] ?? 0).toInt(),
        'microGoal': {
          'fiberGoal': (micro?['fiber_g'] ?? 0).toInt(),
          'sugarGoal': (micro?['sugar_g'] ?? 0).toInt(),
          'sodiumGoal': (micro?['sodium_mg'] ?? 0).toInt(),
        },
      };

      _applyGoalsToHealthState(dailyGoals);

      final uid = _uid;
      if (uid != null) {
        await _userDoc(uid).set(
          {'dailyGoals': dailyGoals},
          SetOptions(merge: true),
        );
      }
    } catch (e, st) {
      debugPrint('fetchGoals API error: $e\n$st');
    }
  }

  // -----------------------------
  // Mappers
  // -----------------------------

  Map<String, dynamic> _goalsToMap(HealthData health, UserData user) => {
    'calorieGoal': health.calorieGoal,
    'proteinGoal': health.proteinGoal,
    'carbsGoal': health.carbsGoal,
    'fatsGoal': health.fatsGoal,
    'weightGoal': user.weightGoal,
    'microGoal': {
      'fiberGoal': health.fiberGoal,
      'sugarGoal': health.sugarGoal,
      'sodiumGoal': health.sodiumGoal,
    },
  };

  Map<String, dynamic> _progressToMap(HealthData health, UserData user) => {
    'caloriesEaten': health.dailyIntake,
    'caloriesBurned': health.dailyBurned,
    'protein': health.dailyProtein,
    'carbs': health.dailyCarbs,
    'fats': health.dailyFats,
    'waterMl': health.dailyWater,
    'microProgress': {
      'fiber': health.dailyFiber,
      'sugar': health.dailySugar,
      'sodium': health.dailySodium,
    },
    'weight': user.weight,
  };

  // -----------------------------
  // Apply to HealthData provider
  // -----------------------------

  void _applyDailyLogToHealthState(Map<String, dynamic> data) {
    final progress = data['dailyProgress'] as Map<String, dynamic>?;
    final microProg = progress?['microProgress'] as Map<String, dynamic>?;

    final goals = data['dailyGoals'] as Map<String, dynamic>?;
    final microGoals = goals?['microGoal'] as Map<String, dynamic>?;

    ref.read(healthDataProvider.notifier).update(
          (s) => s.copyWith(
        dailyIntake: (progress?['caloriesEaten'] ?? 0).toInt(),
        dailyBurned: (progress?['caloriesBurned'] ?? 0).toInt(),
        dailyWater: (progress?['waterMl'] ?? 0).toInt(),
        dailyProtein: (progress?['protein'] ?? 0).toInt(),
        dailyCarbs: (progress?['carbs'] ?? 0).toInt(),
        dailyFats: (progress?['fats'] ?? 0).toInt(),
        dailyFiber: (microProg?['fiber'] ?? 0).toInt(),
        dailySugar: (microProg?['sugar'] ?? 0).toInt(),
        dailySodium: (microProg?['sodium'] ?? 0).toInt(),
        calorieGoal: (goals?['calorieGoal'] ?? 0).toInt(),
        proteinGoal: (goals?['proteinGoal'] ?? 0).toInt(),
        carbsGoal: (goals?['carbsGoal'] ?? 0).toInt(),
        fatsGoal: (goals?['fatsGoal'] ?? 0).toInt(),
        fiberGoal: (microGoals?['fiberGoal'] ?? 0).toInt(),
        sugarGoal: (microGoals?['sugarGoal'] ?? 0).toInt(),
        sodiumGoal: (microGoals?['sodiumGoal'] ?? 0).toInt(),
      ),
    );
  }

  void _applyGoalsToHealthState(Map<String, dynamic> goals) {
    final micro = goals['microGoal'] as Map<String, dynamic>?;

    ref.read(healthDataProvider.notifier).update(
          (s) => s.copyWith(
        calorieGoal: (goals['calorieGoal'] ?? 0).toInt(),
        proteinGoal: (goals['proteinGoal'] ?? 0).toInt(),
        carbsGoal: (goals['carbsGoal'] ?? 0).toInt(),
        fatsGoal: (goals['fatsGoal'] ?? 0).toInt(),
        fiberGoal: (micro?['fiberGoal'] ?? 0).toInt(),
        sugarGoal: (micro?['sugarGoal'] ?? 0).toInt(),
        sodiumGoal: (micro?['sodiumGoal'] ?? 0).toInt(),
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    var age = today.year - birthDate.year;

    final birthdayThisYear = DateTime(today.year, birthDate.month, birthDate.day);
    if (today.isBefore(birthdayThisYear)) age--;

    return age;
  }
}
