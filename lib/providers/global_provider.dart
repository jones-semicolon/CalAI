import 'dart:async';
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
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../services/calai_firestore_service.dart';
import '../features/home_widget/services/home_widget_service.dart';

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
  FutureOr<GlobalDataState> build() {
    // Cleanup listeners when provider is destroyed
    ref.onDispose(() {
      _dailyLogSub?.cancel();
      _historySub?.cancel();
      _weightSub?.cancel();
      _userSub?.cancel();
    });
    return GlobalDataState.initial();
  }

  // ---------------------------------------------------------------------------
  // 2. INITIALIZATION (The Orchestrator)
  // ---------------------------------------------------------------------------

  Future<void> init() async {
    // Prevent double initialization
    if (state.asData?.value.isInitialized == true) return;
    state = const AsyncLoading();

    try {
      await _loadUserProfileIntoUserProvider();
      _syncFirebaseNameIntoUserProvider();

      await _ensureDailyLogExists();
      // await _ensureStatsExists();

      listenToDailySummary(_service.todayId);
      listenToHistory();
      listenToWeightHistory();
      listenToUserProfile();

      // STEP 4: Finalize initialization state
      final current = state.asData?.value ?? GlobalDataState.initial();
      state = AsyncData(current.copyWith(isInitialized: true, userSettings: ref.read(userProvider).settings));

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
      final data = doc.data();

      // If doc doesn't exist yet, we don't clear the state,
      // we just wait for initialization to finish writing it.
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
      // ✅ If the document doesn't exist, initialize it
      if (!snapshot.exists) {
        debugPrint("Weight history doc missing. Initializing...");

        // Get current weight from the user provider state
        final currentWeight = ref.read(userProvider).body.currentWeight;
        final targetWeight = ref.read(userProvider).goal.targets.weightGoal;

        // Log the initial entry (this creates the document)
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
      final data = snapshot.data() ?? {};
      final String currentWeekId = _service.getWeekId(DateTime.now());
      final weekData = data[currentWeekId] as Map<String, dynamic>?;

      final List<DailyNutrition> nutritionLogs = [];
      final Set<String> progressDays = {};

      if (weekData != null) {
        // ✅ FIX 1: Use a fixed order to prevent "Jumping Bars"
        final daysOrder = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

        for (var dayName in daysOrder) {
          if (weekData.containsKey(dayName)) {
            final stats = weekData[dayName] as Map<String, dynamic>;

            if ((stats['kc'] ?? 0) > 0) {
              progressDays.add(dayName);

              // ✅ FIX 2: Ensure the Date is treated as Local time
              // to prevent the "Next Day" shift in the graph logic.
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

      if (!kIsWeb) {
        final streakCount = _calculateStreakFromProgressDays(progressDays);
        unawaited(() async {
          await HomeWidgetService.saveStreakWidgetData(
            streakCount: streakCount,
            dateId: _service.todayId,
          );
          await HomeWidgetService.updateWidget(dateId: _service.todayId);
        }());
      }
    });
  }
  /// Allows UI to switch dates on the dashboard
  void selectDay(String dateId) {
    final current = state.asData?.value ?? GlobalDataState.initial();
    state = AsyncData(current.copyWith(activeDateId: dateId));
    listenToDailySummary(dateId);
  }

  // ---------------------------------------------------------------------------
  // 4. DATA SYNC HELPERS
  // ---------------------------------------------------------------------------

  int _calculateStreakFromProgressDays(Set<String> progressDays) {
    final daysOrder = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];

    final week = List<bool>.generate(
      7,
          (i) => progressDays.contains(daysOrder[i]),
    );

    if (week.length != 7) return 0;
    final today = DateTime.now().weekday % 7;

    var streak = 0;
    for (var i = today; i >= 0; i--) {
      if (week[i]) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  void _applyDailyLogToState(Map<String, dynamic> data, String dateId) {
    final progress = NutritionProgress.fromDailyLog(data);

    final masterTargets = ref.read(userProvider).goal.targets;
    final goals = (data['dailyGoals'] != null)
        ? NutritionGoals.fromJson(data['dailyGoals'])
        : masterTargets;

    final current = state.asData?.value ?? GlobalDataState.initial();

    state = AsyncData(current.copyWith(
      todayProgress: progress,
      todayGoal: goals,
      calorieGoal: goals.calories.toDouble(),
      activeDateId: dateId,
    ));

    if (!kIsWeb) {
      final settings = ref.read(userProvider).settings;
      final isAddBurnEnabled = settings.isAddCalorieBurn ?? false;
      final isRolloverEnabled = settings.isRollover ?? false;
      final num baseGoal = goals.calories;
      num effectiveGoal = baseGoal;
      if (isRolloverEnabled) effectiveGoal += goals.rollover;
      if (isAddBurnEnabled) effectiveGoal += progress.caloriesBurned;
      final streakCount = _calculateStreakFromProgressDays(current.progressDays);

      unawaited(() async {
        await HomeWidgetService.saveCalorieWidgetData(
          calories: progress.calories.round(),
          calorieGoal: effectiveGoal.round(),
          dateId: dateId,
          protein: progress.protein.round(),
          proteinGoal: goals.protein.round(),
          carbs: progress.carbs.round(),
          carbsGoal: goals.carbs.round(),
          fats: progress.fats.round(),
          fatsGoal: goals.fats.round(),
          streakCount: streakCount,
        );
        await HomeWidgetService.updateWidget(dateId: dateId);
      }());
    }
  }

  Future<void> _loadUserProfileIntoUserProvider() async {
    final doc = await _service.userDoc.get();
    final data = doc.data();
    if (data == null) return;

    final userNotifier = ref.read(userProvider.notifier);

    // Load Body Stats
    final body = data['body'] as Map<String, dynamic>? ?? {};
    if (body['height'] != null) {
      userNotifier.setHeight(cm: (body['height'] as num).toDouble(), unit: HeightUnit.cm);
    }
    if (body['currentWeight'] != null) {
      userNotifier.setWeight((body['currentWeight'] as num).toDouble(), WeightUnit.kg);
    }

    // Load Master Goal Object
    if (data['goal']['dailyGoals'] != null) {
      userNotifier.setUserGoal(UserGoal.fromJson(data['goal']));
    }
  }

  void listenToUserProfile() {
    if (_service.uid == null) return;

    _userSub?.cancel();
    _userSub = _service.userDoc.snapshots().listen((doc) {
      final data = doc.data();
      if (data == null) return;

      final userNotifier = ref.read(userProvider.notifier);

      // 1. Check if the profile map exists in the document
      if (data['profile'] != null) {
        // 2. Parse the ENTIRE profile using your factory
        final updatedProfile = UserProfile.fromJson(data['profile'] as Map<String, dynamic>);

        // 3. Update the local state with the complete profile object
        userNotifier.updateLocal((s) => s.copyWith(
          profile: updatedProfile,
        ));
      }
    });
  }

  Future<void> _ensureDailyLogExists() async {
    final user = ref.read(userProvider);
    final masterTargets = user.goal.targets;

    // Don't create if master targets aren't loaded yet
    if (masterTargets.calories == 0) return;

    final dayRef = _service.dailyLogDoc(_service.todayId);
    final doc = await dayRef.get();
    final existingData = doc.data();

    // Create or update missing dailyGoals
    if (!doc.exists || existingData?['dailyGoals'] == null) {
      int rolloverAmount = await _calculateYesterdayRollover();

      await dayRef.set({
        'date': _service.todayId,
        'dailyGoals': {
          ...masterTargets.toJson(),
          'weightGoal': masterTargets.weightGoal,
          'rollover': rolloverAmount,
        },
        'dailyProgress': {
          'weight': user.body.currentWeight,
        },
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<int> _calculateYesterdayRollover() async {
    try {
      final user = ref.read(userProvider);
      // if (user.settings.isRollover!) return 0;

      // 1. Get Yesterday's ID based on Local Time to match your Firestore keys
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

  void _syncFirebaseNameIntoUserProvider() {
    final fbUser = FirebaseAuth.instance.currentUser;
    final currentName = ref.read(userProvider).profile.name;
    if (fbUser?.displayName != null && (currentName == null || currentName.isEmpty)) {
      ref.read(userProvider.notifier).setName(fbUser!.displayName!);
    }
  }
}
