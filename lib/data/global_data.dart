import 'dart:async';
import 'dart:convert';

import 'package:calai/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../api/food_api.dart';
import 'global_data_state.dart';
import 'health_data.dart';

enum FoodSource { foodDatabase("food-database"), foodUpload("food-upload"), exercise("exercise"); final String value; const FoodSource(this.value);}

final globalDataProvider =
AsyncNotifierProvider<GlobalDataNotifier, GlobalDataState>(
  GlobalDataNotifier.new,
);

// This provider manages the stream and prevents it from restarting on every UI change
final dailyEntriesProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, dateId) {
  return ref.read(globalDataProvider.notifier).watchEntries(dateId);
});

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

  CollectionReference<Map<String, dynamic>> _savedFood(String uid) =>
      _userDoc(uid).collection('savedFoods');

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
    if (state.asData?.value.isInitialized == true) return;

    state = const AsyncLoading();

    try {
      _syncFirebaseNameIntoUserProvider();
      await _loadUserProfileIntoUserProvider();

      // ✅ READ ONLY — no API
      await loadGoalsFromFirestore();

      await ensureDailyLogExists();

      listenToDailySummary(_todayId);
      listenToProgressLogs();

      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(current.copyWith(isInitialized: true));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Stream<List<Map<String, dynamic>>> watchEntries(String dateId) {
    final uid = _uid;
    if (uid == null) return const Stream.empty();

    return _dailyLogDoc(uid, dateId)
        .collection('entries')
        .orderBy('timestamp', descending: true) // Newest items at the top
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
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

  Future<void> logExerciseEntry({
    int? id,
    required double burnedCalories,
    required double weightKg,
    required String exerciseType,
    required String intensity,
    required int durationMins,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final dayRef = _dailyLogDoc(uid, _todayId);
    final source = "exercise";

    // Use provided ID or generate a string ID based on time
    final entryId = id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();

    final batch = _db.batch();

    // ✅ 1) Save the specific exercise entry
    final entryRef = dayRef.collection('entries').doc(entryId);

    batch.set(entryRef, {
      'id': entryId,
      'source': source,
      'exerciseType': exerciseType,
      'intensity': intensity,
      'durationMins': durationMins,
      'caloriesBurned': burnedCalories,
      'weightKg': weightKg,
      'timestamp': FieldValue.serverTimestamp(),
    });

    batch.set(
      dayRef,
      {
        'dailyProgress': {
          // OPTION A: Recommended - Track burned separately
          'caloriesBurned': FieldValue.increment(burnedCalories),

          // OPTION B: If you strictly want to subtract from eaten (Net Calories approach)
          // 'caloriesEaten': FieldValue.increment(-burnedCalories),
        },
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Future<void> logFoodEntry({
    String? id,
    required String name,
    required int calories,
    required int p,
    required int c,
    required int f,
    required int serving,
    required FoodSource source,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final dayRef = _dailyLogDoc(uid, _todayId);

    // ✅ generate entryId
    final entryId = source == FoodSource.foodUpload
        ? _makeEntryId(source: source, id: id)
        : id;

    if (entryId == null) {
      throw Exception("Food ID is required for non-upload foods.");
    }

    final entryRef = dayRef.collection('entries').doc(entryId.toString());

    // ✅ 1) get current dailyProgress (SAFE)
    final snap = await dayRef.get();
    final data = snap.data();

    final dp = (data?['dailyProgress'] as Map<String, dynamic>?) ?? {};

    double _num(dynamic v) => (v is num) ? v.toDouble() : 0.0;

    final newDailyProgress = {
      'caloriesEaten': _num(dp['caloriesEaten']) + calories,
      'protein': _num(dp['protein']) + p,
      'carbs': _num(dp['carbs']) + c,
      'fats': _num(dp['fats']) + f,
    };

    final batch = _db.batch();

    // ✅ 2) save entry
    batch.set(entryRef, {
      'id': entryId,
      'source': source.value,
      'name': name,
      'serving': serving,
      'calories': calories,
      'macros': {'p': p, 'c': c, 'f': f},
      'timestamp': FieldValue.serverTimestamp(),
    });

    // ✅ 3) write back the whole dailyProgress map (FIXED)
    batch.set(
      dayRef,
      {
        'dailyProgress': newDailyProgress,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  String _makeEntryId({
    required dynamic source,
    String? id,
  }) {
    if (source == FoodSource.foodUpload || source == "exercise") {
      return "00${DateTime.now().millisecondsSinceEpoch}";
    }

    if (id == null) {
      throw Exception("Missing fdcId for API food.");
    }

    return id.toString();
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
    debugPrint('updateProfile: $uid');
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

  Future<void> saveFood(FoodSearchItem item) async {
    final uid = _uid;
    if (uid == null) return;

    await _savedFood(uid).doc(item.fdcId.toString()).set(
      {
        ...item.toJson(),
        'savedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> fetchGoals() async {
    final uid = _uid;
    if (uid == null) return;

    final doc = await _userDoc(uid).get();
    if (doc.data()?['dailyGoals'] != null) {
      debugPrint("Goals already exist — skipping API");
      return;
    }

    final user = ref.read(userProvider);

    try {
      final uri = Uri.https(
        "cal-ai-liard.vercel.app",
        "/calculate-goals",
        {
          "age": _calculateAge(user.birthDay).toString(),
          "gender": user.gender.value,
          "height": user.height.toString(),
          "weight": user.weight.toString(),
          "activity_level": user.workOutPerWeek.value,
          "goal": user.goal.value,
        },
      );

      final response = await http.get(uri);
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

      await _userDoc(uid).set(
        {'dailyGoals': dailyGoals},
        SetOptions(merge: true),
      );
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
