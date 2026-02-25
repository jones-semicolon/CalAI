import 'dart:async';
import 'package:calai/providers/auth_state_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Project Imports
import '../enums/food_enums.dart';
import '../enums/user_enums.dart';
import '../models/exercise_model.dart';
import '../models/global_state_model.dart';
import '../models/nutrition_model.dart';
import '../models/user_model.dart' hide User;
import '../providers/user_provider.dart';
import '../services/calai_firestore_service.dart';

// -----------------------------------------------------------------------------
// 1. PROVIDER DEFINITION
// -----------------------------------------------------------------------------
final globalDataProvider =
AsyncNotifierProvider<GlobalDataNotifier, GlobalDataState>(
  GlobalDataNotifier.new,
);

class GlobalDataNotifier extends AsyncNotifier<GlobalDataState> {
  StreamSubscription? _dailyLogSub;
  StreamSubscription? _historySub; // Consolidates weekly nutrition and weight
  StreamSubscription? _weightSub;
  StreamSubscription? _userSub;

  // Access the extracted service for DB operations
  CalaiFirestoreService get _service => ref.read(calaiServiceProvider);

  @override
  FutureOr<GlobalDataState> build() async {
    // Cleanup when destroyed
    ref.onDispose(() {
      _dailyLogSub?.cancel();
      _historySub?.cancel();
      _weightSub?.cancel();
      _userSub?.cancel();
    });

    // Wait for Firebase Auth to be fully initialized
    final authAsync = ref.watch(authStateProvider);
    final user = await authAsync.when(
      data: (user) => user,
      loading: () async {
        // Wait a short moment until auth is ready
        await Future.delayed(const Duration(milliseconds: 100));
        return ref.watch(authStateProvider).value;
      },
      error: (_, __) => null,
    );

    if (user == null) {
      debugPrint("🔒 GlobalData disposed (no auth)");
      return GlobalDataState.initial();
    }

    // Start Firestore initialization
    await init();

    return state.value ?? GlobalDataState.initial();
  }

  // ---------------------------------------------------------------------------
  // 2. INITIALIZATION (The Orchestrator)
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    if (state.asData?.value.isInitialized == true) return;
    state = const AsyncLoading();

    try {
      // 2. Load and Listen
      await _loadUserProfileIntoUserProvider();

      await _ensureDailyLogExists();
      listenToDailySummary(_service.todayId);
      listenToHistory();
      listenToWeightHistory();
      listenToUserProfile();

      // Finalize
      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(current.copyWith(
          isInitialized: true,
          userSettings: ref.read(userProvider).settings
      ));
    } catch (e, st) {
      debugPrint("❌ GlobalData Init Error: $e");
      state = AsyncError(e, st);
    }
  }

  // ---------------------------------------------------------------------------
  // 3. LIVE LISTENERS (Streams)
  // ---------------------------------------------------------------------------

  /// Listens to a specific date document for real-time calorie circle updates.
  void listenToDailySummary(String dateId) {
    if (_service.uid == null) return;

    _dailyLogSub?.cancel();
    _dailyLogSub = _service.dailyLogDoc(dateId).snapshots().listen((doc) {
      if (!ref.mounted) return;
      final data = doc.data();

      if (!doc.exists || data == null) return;

      _applyDailyLogToState(data, dateId);
    });
  }

  // ---------------------------------------------------------------------------
  // NEW: Weight History Listener
  // ---------------------------------------------------------------------------
  void listenToWeightHistory() {
    if (_service.uid == null) return;

    _weightSub?.cancel();
    _weightSub = _service.weightHistory.snapshots().listen((snapshot) async {
      if (!snapshot.exists) {
        if (!ref.mounted) return;
        debugPrint("Weight history doc missing. Initializing...");

        final currentWeight = ref.read(userProvider).body.currentWeight;
        final targetWeight = ref.read(userProvider).goal.targets.weightGoal;

        await _service.logWeightEntry(
            currentWeight,
            newTargetWeight: targetWeight.toDouble()
        );
        return;
      }

      final data = snapshot.data()!;
      final List<WeightLog> logs = [];

      final historyData = data['history'];
      if (historyData is Map<String, dynamic>) {
        historyData.forEach((dateKey, value) {
          final date = DateTime.tryParse(dateKey);
          final nestedMap = value as Map<String, dynamic>;
          final weight = (nestedMap['w'] as num?)?.toDouble() ?? 0.0;

          if (date != null) {
            logs.add(WeightLog(date: date, weight: weight));
          }
        });
      }

      logs.sort((a, b) => a.date.compareTo(b.date));

      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(current.copyWith(
        weightLogs: logs,
        goalWeight: (data['targetWeight'] as num?)?.toDouble() ?? 0.0,
      ));
    });
  }

  void listenToHistory() {
    if (_service.uid == null) return;

    _historySub?.cancel();
    _historySub = _service.weeklyNutritionDoc.snapshots().listen((snapshot) {
      if (!ref.mounted) return;
      final data = snapshot.data() ?? {};
      final String currentWeekId = _service.getWeekId(DateTime.now());
      final weekData = data[currentWeekId] as Map<String, dynamic>?;

      final List<DailyNutrition> nutritionLogs = [];
      final Set<String> progressDays = {};

      if (weekData != null) {
        final daysOrder = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

        for (var dayName in daysOrder) {
          if (weekData.containsKey(dayName)) {
            final stats = weekData[dayName] as Map<String, dynamic>;

            if ((stats['kc'] ?? 0) > 0) {
              progressDays.add(dayName);
              final DateTime logDate = (stats['date'] as Timestamp).toDate().toLocal();

              nutritionLogs.add(DailyNutrition(
                date: logDate,
                kc: (stats['kc'] as num).toInt(),
                p: (stats['p'] as num).toInt(),
                c: (stats['c'] as num).toInt(),
                f: (stats['f'] as num).toInt(),
              ));
            }
          }
        }
      }

      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(current.copyWith(
        dailyNutrition: nutritionLogs,
        progressDays: progressDays,
      ));
    });
  }
  void selectDay(String dateId) {
    final current = state.asData?.value ?? GlobalDataState.initial();
    state = AsyncData(current.copyWith(activeDateId: dateId));
    listenToDailySummary(dateId);
  }

  // ---------------------------------------------------------------------------
  // 4. DATA SYNC HELPERS
  // ---------------------------------------------------------------------------

  void _applyDailyLogToState(Map<String, dynamic> data, String dateId) {
    final progress = NutritionProgress.fromDailyLog(data);

    final masterTargets = ref.read(userProvider).goal.targets;
    final goals = (data['dailyGoals'] != null)
        ? NutritionGoals.fromJson(data['dailyGoals'])
        : masterTargets;

    final currentValue = state.value ?? GlobalDataState.initial();

    state = AsyncData(currentValue.copyWith(
      todayProgress: progress,
      todayGoal: goals,
      calorieGoal: goals.calories.toDouble(),
      activeDateId: dateId,
    ));
  }

  Future<void> _loadUserProfileIntoUserProvider() async {
    final doc = await _service.userDoc.get();
    final data = doc.data();
    if (data == null) return;

    final userNotifier = ref.read(userProvider.notifier);

    userNotifier.updateLocal((state) => state.copyWith(id: doc.id));

    final body = data['body'] as Map<String, dynamic>? ?? {};
    if (body['height'] != null) {
      userNotifier.setHeight(cm: (body['height'] as num).toDouble(), unit: HeightUnit.cm);
    }
    if (body['currentWeight'] != null) {
      userNotifier.setWeight((body['currentWeight'] as num).toDouble(), WeightUnit.kg);
    }

    if (data['goal']['dailyGoals'] != null) {
      userNotifier.setUserGoal(UserGoal.fromJson(data['goal']));
    }
  }

  void listenToUserProfile() {
    if (_service.uid == null) return;

    _userSub?.cancel();
    _userSub = _service.userDoc.snapshots().listen((doc) {
      if (!ref.mounted) return;
      final data = doc.data();
      if (data == null) return;

      final userNotifier = ref.read(userProvider.notifier);

      if (data['profile'] != null) {
        final updatedProfile = UserProfile.fromJson(data['profile'] as Map<String, dynamic>);

        userNotifier.updateLocal((s) => s.copyWith(
          profile: updatedProfile,
        ));
      }
    });
  }

  Future<void> _ensureDailyLogExists() async {
    final user = ref.read(userProvider);
    
    if (user.goal.targets.calories == 0) {
      debugPrint("⏳ Master targets not ready. Postponing log creation.");
      return;
    }

    final dayRef = _service.dailyLogDoc(_service.todayId);
    final doc = await dayRef.get();
    
    if (!doc.exists || doc.data()?['dailyGoals'] == null && doc.data()?['dailyGoals']['calories'] == null) {
      debugPrint("🌅 Initializing new day: ${_service.todayId}");
      
      final int rollover = await _calculateYesterdayRollover();

      await dayRef.set({
        'date': _service.todayId,
        'dailyGoals': {
          ...user.goal.targets.toJson(),
          'rollover': rollover,
        },
        'dailyProgress': {
          if (!doc.exists) 'weight': user.body.currentWeight,
          if (!doc.exists) 'caloriesEaten': 0,
          if (!doc.exists) 'caloriesBurned': 0,
          if (!doc.exists) 'water': 0,
          if (!doc.exists) 'steps': 0,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> disposeListeners() async {
    await _dailyLogSub?.cancel();
    await _historySub?.cancel();
    await _weightSub?.cancel();
    await _userSub?.cancel();

    _dailyLogSub = null;
    _historySub = null;
    _weightSub = null;
    _userSub = null;

    debugPrint("🔥 Firestore listeners stopped BEFORE logout");
  }

  Future<void> updateWater(int newWater) async {
    final dayRef = _service.dailyLogDoc(_service.todayId);

    await dayRef.set({
      'date': _service.todayId,
      'dailyProgress': {
        'water': FieldValue.increment(newWater),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<int> _calculateYesterdayRollover() async {
    try {
      final now = DateTime.now().toLocal();
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayId = DateFormat('yyyy-MM-dd').format(yesterday);

      final doc = await _service.dailyLogDoc(yesterdayId).get();
      if (!doc.exists) return 0;

      final data = doc.data()!;
      final goals = data['dailyGoals'] as Map<String, dynamic>?;
      final progress = data['dailyProgress'] as Map<String, dynamic>?;

      final int goal = (goals?['calories'] as num?)?.toInt() ??
          (goals?['calorieGoal'] as num?)?.toInt() ?? 0;

      final int eaten = (progress?['caloriesEaten'] as num?)?.toInt() ?? 0;

      final int surplus = goal - eaten;

      if (surplus <= 0) return 0;

      const int maxRollover = 200;
      return surplus > maxRollover ? maxRollover : surplus;

    } catch (e) {
      debugPrint("⚠️ Rollover Error: $e");
      return 0;
    }
  }
}