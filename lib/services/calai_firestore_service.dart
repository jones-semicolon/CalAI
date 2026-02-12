import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../api/goals_api.dart';
import '../enums/food_enums.dart';
import '../enums/user_enums.dart';
import '../models/exercise_model.dart';
import '../models/food_model.dart';
import '../models/user_model.dart';

/// Handles all Database interactions and API calls
class CalaiFirestoreService {
  final Ref ref;
  final GoalsApi _goalsApi = GoalsApi();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CalaiFirestoreService(this.ref);

  // --- Getters ---
  String? get uid => _auth.currentUser?.uid;
  String get todayId => DateTime.now().toIso8601String().split('T').first;

  // --- Paths ---
  DocumentReference<Map<String, dynamic>> get userDoc =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> get dailyLogsCol =>
      userDoc.collection('dailyLogs');

  DocumentReference<Map<String, dynamic>> dailyLogDoc(String date) =>
      dailyLogsCol.doc(date);

  CollectionReference<Map<String, dynamic>> get savedFoodCol =>
      userDoc.collection('savedFoods');

  CollectionReference<Map<String, dynamic>> get stats =>
      userDoc.collection('stats');

  // Stores weekly nutrition p, c, f, kc
  DocumentReference<Map<String, dynamic>> get weeklyNutritionDoc =>
      stats.doc('weekly_nutrition');

  DocumentReference<Map<String, dynamic>> get weightHistory =>
      stats.doc('weight_history');

  DocumentReference<Map<String, dynamic>> get progressPhotos =>
      stats.doc('progress_photos');

  // ---------------------------------------------------------------------------
  // 1. FULL PROFILE SAVE (The "Big Save")
  // ---------------------------------------------------------------------------

  Future<void> updateProfile(User user) async {
    if (uid == null) return;

    try {
      debugPrint("💾 Saving full User object to Firestore...");

      // ✅ 1. Get Clean, Nested JSON
      final userData = user.toJson();

      if (userData['profile'] != null && userData['profile'] is Map) {
        final profile = userData['profile'] as Map<String, dynamic>;

        // If local state is still the default 'anonymous', don't push these fields
        if (profile['provider'] == 'anonymous') {
          profile.remove('provider');

          // Check if the name is the default one before removing
          // (Optional: only remove if it's "user" or "Anonymous")
          if (profile['name'] == 'user' || profile['name'] == 'Anonymous') {
            profile.remove('name');
          }

          debugPrint("🛡️ Protected 'provider' and 'name' from being reverted to defaults.");
        }

        if(userData['uid'] != null) {
          userData.remove('uid');
        }
      }

      // ✅ 2. Add Timestamp
      userData['updatedAt'] = FieldValue.serverTimestamp();

      // ✅ 3. Save Atomic (Merge ensures we don't delete missing fields)
      await userDoc.set(userData, SetOptions(merge: true));

      debugPrint("✅ User saved successfully.");
    } catch (e) {
      debugPrint("❌ Error updating profile: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 2. PARTIAL UPDATES (Settings / Biometrics)
  // ---------------------------------------------------------------------------

  /// Updates a single field in the 'profile' map (e.g. name, birthDate)
  Future<void> updateUserProfileField(String field, dynamic value) async {
    if (uid == null) return;

    // ✅ AUTO-FIX: Prepend 'profile.' so it nests correctly
    // Input: 'name' -> Path: 'profile.name'
    await userDoc.update({
      'profile.$field': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ---------------------------------------------------------------------------
  // 2. PARTIAL UPDATES (Settings / Biometrics)
  // ---------------------------------------------------------------------------

  /// Updates weight and ensures it is synced across Master, Daily, and History docs.
  /// Updates weight across Master, Daily Log, and the consolidated History array.
  Future<void> logWeightEntry(double weight, {double? newTargetWeight}) async {
    if (uid == null) return;

    final batch = _db.batch();
    final String dateKey = todayId; // YYYY-MM-DD

    // 1. Update Master Profile
    batch.update(userDoc, {
      'body.currentWeight': weight,
      if (newTargetWeight != null)
        'goal.dailyGoals.weightGoal': newTargetWeight,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 2. Update Today's Daily Log
    batch.update(dailyLogDoc(dateKey), {
      'dailyProgress.weight': weight,
      if (newTargetWeight != null) 'dailyGoals.weightGoal': newTargetWeight,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final Map<String, dynamic> historyData = {
      if (newTargetWeight != null) 'targetWeight': newTargetWeight,
      'history': {
        dateKey: {
          'w': weight,
          'date': dateKey,
        }
      },
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    // Use update or set with merge for history
    batch.set(weightHistory, historyData, SetOptions(merge: true));
    await batch.commit();
  }

  /// Updates a single field in the 'body' map (e.g. currentWeight, height)
  Future<void> updateUserBodyField(String field, dynamic value) async {
    if (uid == null) return;

    final batch = _db.batch();

    // 1. Update the Master Record (Nested under 'body')
    // Input: 'currentWeight' -> Path: 'body.currentWeight'
    batch.update(userDoc, {
      'body.$field': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 2. If it's weight, also log it to today's progress
    if (field == 'currentWeight') {
      batch.set(dailyLogDoc(todayId), {
        'dailyProgress': {'weight': value},
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  Future<void> updateUserSettings(UserSettings settings) async {
    if (uid == null) return;

    // ✅ Uses UserSettings.toJson() for safety
    await userDoc.set({
      'settings': settings.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ---------------------------------------------------------------------------
  // 3. LOGGING (Food & Exercise)
  // ---------------------------------------------------------------------------

  Future<void> logFoodEntry(
    FoodLog item,
    SourceType source, {
    String? dateId,
  }) async {
    if (uid == null) return;

    final DateTime targetDate = DateTime.parse(dateId ?? todayId);
    final String dateString = DateFormat('yyyy-MM-dd').format(targetDate);
    final dayRef = dailyLogDoc(dateString);

    final String weekId = getWeekId(targetDate);
    final String dayName = getDayName(targetDate);

    final entryId = DateTime.now().millisecondsSinceEpoch.toString();
    final batch = _db.batch();

    // 1. Add Entry to Sub-collection
    batch.set(dayRef.collection('entries').doc(entryId), {
      ...item.toJson(),
      'id': entryId,
      'source': source.value, // Enum -> String
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. Update Daily Totals (Flattened under dailyProgress)
    batch.set(dayRef, {
      'date': targetDate, // Store DateTime object for sorting if needed
      'dailyProgress': {
        'caloriesEaten': FieldValue.increment(item.calories),
        'protein': FieldValue.increment(item.protein),
        'carbs': FieldValue.increment(item.carbs),
        'fats': FieldValue.increment(item.fats),
        'sodium': FieldValue.increment(item.sodium),
        'sugar': FieldValue.increment(item.sugar),
        'fiber': FieldValue.increment(item.fiber),
        'water': FieldValue.increment(item.water),
      },
    }, SetOptions(merge: true));

    // 3. Update Weekly Stats (Embedded Map)
    // Path: 2026_W06 -> monday -> p/c/f
    batch.set(weeklyNutritionDoc, {
      weekId: {
        dayName: {
          'p': FieldValue.increment(item.protein),
          'c': FieldValue.increment(item.carbs),
          'f': FieldValue.increment(item.fats),
          'kc': FieldValue.increment(item.calories),
          'date': targetDate,
        },
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> updateFoodEntry(FoodLog oldItem, FoodLog newItem) async {
    if (uid == null) return;

    final DateTime targetDate = newItem.timestamp;
    final String dateString = DateFormat('yyyy-MM-dd').format(targetDate);
    final dayRef = dailyLogDoc(dateString);

    final String weekId = getWeekId(targetDate);
    final String dayName = getDayName(targetDate);

    final batch = _db.batch();
    final entryRef = dayRef.collection('entries').doc(newItem.id);

    // 1. Calculate the Delta (Difference)
    // If you ate 500kcal before and now it's 300kcal, we increment by -200.
    final num diffCalories = newItem.calories - oldItem.calories;
    final num diffProtein = newItem.protein - oldItem.protein;
    final num diffCarbs = newItem.carbs - oldItem.carbs;
    final num diffFats = newItem.fats - oldItem.fats;
    final num diffSodium = newItem.sodium - oldItem.sodium;
    final num diffSugar = newItem.sugar - oldItem.sugar;
    final num diffFiber = newItem.fiber - oldItem.fiber;
    final num diffWater = newItem.water - oldItem.water;

    debugPrint("newItem: ${newItem.toJson().toString()}");
    debugPrint("oldItem: ${oldItem.toJson().toString()}");
    debugPrint("diffCalories: $diffCalories");

    // 2. Update the specific entry document
    batch.update(entryRef, {
      ...newItem.toJson(),
      'timestamp': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 3. Adjust Daily Totals using the Delta
    batch.update(dayRef, {
      'dailyProgress.caloriesEaten': FieldValue.increment(diffCalories),
      'dailyProgress.protein': FieldValue.increment(diffProtein),
      'dailyProgress.carbs': FieldValue.increment(diffCarbs),
      'dailyProgress.fats': FieldValue.increment(diffFats),
      'dailyProgress.sodium': FieldValue.increment(diffSodium),
      'dailyProgress.sugar': FieldValue.increment(diffSugar),
      'dailyProgress.fiber': FieldValue.increment(diffFiber),
      'dailyProgress.water': FieldValue.increment(diffWater),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 4. Adjust Weekly Stats using the Delta
    batch.set(weeklyNutritionDoc, {
      weekId: {
        dayName: {
          'p': FieldValue.increment(diffProtein),
          'c': FieldValue.increment(diffCarbs),
          'f': FieldValue.increment(diffFats),
          'kc': FieldValue.increment(diffCalories),
        },
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  // ---------------------------------------------------------------------------
  // 3. LOGGING (Exercise Update)
  // ---------------------------------------------------------------------------

  Future<void> updateExerciseEntry(ExerciseLog oldItem, ExerciseLog newItem) async {
    if (uid == null) return;

    // 1. Identify paths (Uses existing dateId or defaults to today)
    final DateTime? targetDate = newItem.timestamp;
    final String dateString = DateFormat('yyyy-MM-dd').format(targetDate!);
    final dayRef = dailyLogDoc(dateString);

    final batch = _db.batch();
    final entryRef = dayRef.collection('entries').doc(newItem.id);

    // 2. Calculate the Delta (Difference)
    // If you logged 300kcal burned but edited it to 400kcal, we increment by +100.
    final num diffCaloriesBurned = newItem.caloriesBurned - oldItem.caloriesBurned;

    // 3. Update the specific entry document with new data
    batch.update(entryRef, {
      ...newItem.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 4. Adjust the Daily Progress 'caloriesBurned' total using the Delta
    // This ensures your "Calories Remaining" circle on the dashboard updates correctly.
    batch.set(dayRef, {
      'dailyProgress': {
        'caloriesBurned': FieldValue.increment(diffCaloriesBurned),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
    debugPrint("✅ Exercise entry updated: ${newItem.id} (Delta: $diffCaloriesBurned)");
  }

  Future<void> logExerciseEntry({
    required ExerciseLog exercise,
    String? dateId,
  }) async {
    if (uid == null) return;

    final targetDate = dateId ?? todayId;
    final dayRef = dailyLogDoc(targetDate);
    final entryId = DateTime.now().millisecondsSinceEpoch.toString();

    final batch = _db.batch();

    batch.set(dayRef.collection('entries').doc(entryId), {
      'source': SourceType.exercise.value,
      'id': entryId,
      ...exercise.toJson(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    batch.set(dayRef, {
      'dailyProgress': {
        'caloriesBurned': FieldValue.increment(exercise.caloriesBurned),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> deleteLogEntry(String dateId, dynamic item) async {
    if (uid == null) return;

    // Date Helpers
    final DateTime targetDate = DateTime.parse(dateId);
    final String dateString = DateFormat('yyyy-MM-dd').format(targetDate);
    final dayRef = dailyLogDoc(dateString);
    final String weekId = getWeekId(targetDate);
    final String dayName = getDayName(targetDate);

    final batch = _db.batch();
    final entryRef = dayRef.collection('entries').doc(item.id);

    // 1. Delete the specific entry
    batch.delete(entryRef);

    // 2. Decrement Totals
    if (item is FoodLog) {
      batch.set(dayRef, {
        'dailyProgress': {
          'caloriesEaten': FieldValue.increment(-item.calories),
          'protein': FieldValue.increment(-item.protein),
          'carbs': FieldValue.increment(-item.carbs),
          'fats': FieldValue.increment(-item.fats),
          'sodium': FieldValue.increment(-item.sodium),
          'sugar': FieldValue.increment(-item.sugar),
          'fiber': FieldValue.increment(-item.fiber),
          'water': FieldValue.increment(-item.water),
        },
      }, SetOptions(merge: true));

      // Decrement Weekly Stats
      batch.set(weeklyNutritionDoc, {
        weekId: {
          dayName: {
            'p': FieldValue.increment(-item.protein),
            'c': FieldValue.increment(-item.carbs),
            'f': FieldValue.increment(-item.fats),
            'kc': FieldValue.increment(-item.calories),
          },
        },
      }, SetOptions(merge: true));
    } else if (item is ExerciseLog) {
      batch.set(dayRef, {
        'dailyProgress': {
          'caloriesBurned': FieldValue.increment(-item.caloriesBurned),
        },
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  // ---------------------------------------------------------------------------
  // 4. GOALS & API
  // ---------------------------------------------------------------------------

  Future<void> updateTargetWeight(double weight, Goal goalType) async {
    if (uid == null) return;

    final batch = _db.batch();

    // 1. Update Root (Using Dot Notation to preserve other goal fields)
    batch.update(userDoc, {
      'goal.type': goalType.name,       // ✅ And here
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 2. Update Today's Log
    batch.update(dailyLogDoc(todayId), {
      'dailyGoals.weightGoal': weight,
    });

    await batch.commit();
  }

  Future<UserGoal?> fetchGoals(
    User user, {
    bool forceRefresh = false,
    bool save = true,
  }) async {
    if (uid == null) return null;

    if (!forceRefresh) {
      final doc = await userDoc.get();

      if (doc.data()?['dailyGoals'] != null) {
        debugPrint("✅ Found existing goals.");
        return UserGoal.fromJson({'dailyGoals': doc.data()!['dailyGoals']});
      }
    }

    final Map<String, dynamic>? dailyGoals = await _goalsApi.calculateGoals(
      user,
    );

    if (dailyGoals != null) {
      debugPrint("🔍 Calculated Goals: $dailyGoals");

      dailyGoals['weightGoal'] = user.goal.targets.weightGoal;

      if (save) {
        // We save this to 'dailyGoals' so it is easily accessible
        // AND we should also merge it into 'goal.dailyGoals' to keep the User model sync
        await updateDailyGoals(dailyGoals);
      }

      return UserGoal.fromJson({'dailyGoals': dailyGoals});
    }
    return null;
  }

  Future<void> updateDailyGoals(Map<String, dynamic> goals) async {
    final batch = _db.batch();

    // 1. Root convenience field (for quick stats access)
    batch.set(userDoc, {'dailyGoals': goals}, SetOptions(merge: true));

    // 2. Nested field (for User model integrity)
    batch.set(userDoc, {
      'goal': {'dailyGoals': goals},
    }, SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> syncSteps(int steps) async {
    if (uid == null) return;

    final batch = _db.batch();
    final String dateKey = todayId;

    // Update Daily Progress
    batch.set(dailyLogDoc(dateKey), {
      'dailyProgress': { 'steps': steps },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  /// Fetches raw weight history and parses the Map structure.
  Future<List<WeightLog>> getWeightHistory() async {
    if (uid == null) return [];

    try {
      final doc = await weightHistory.get();
      if (!doc.exists) return [];

      final data = doc.data()!;
      final Map<String, dynamic> history =
          data['history'] as Map<String, dynamic>? ?? {};
      final List<WeightLog> logs = [];

      history.forEach((dateStr, weight) {
        debugPrint(weight);
        final date = DateTime.tryParse(dateStr);
        if (date != null) {
          logs.add(WeightLog(date: date, weight: (weight as num).toDouble()));
        }
      });

      // Sort chronologically
      logs.sort((a, b) => a.date.compareTo(b.date));
      return logs;
    } catch (e) {
      debugPrint("❌ FirestoreService: Error fetching weight logs: $e");
      return [];
    }
  }

  /// Fetches the start and target weights from the consolidated stats doc.
  Future<Map<String, double?>> getWeightBoundaries() async {
    if (uid == null) return {'start': null, 'target': null};

    final doc = await weightHistory.get();
    final data = doc.data() ?? {};

    return {
      'start': (data['startWeight'] as num?)?.toDouble(),
      'target': (data['targetWeight'] as num?)?.toDouble(),
    };
  }

  /// Fetches the current goal weight from the root user document.
  Future<double?> getMasterGoalWeight() async {
    if (uid == null) return null;

    final doc = await userDoc.get();
    final data = doc.data() ?? {};

    final goalData = data['goal'] as Map<String, dynamic>?;
    final target =
        goalData?['weightGoal'] ?? data['dailyGoals']?['weightGoal'];

    return target != null ? (target as num).toDouble() : null;
  }

  // ---------------------------------------------------------------------------
  // 5. SAVED FOODS
  // ---------------------------------------------------------------------------

  Future<void> saveFood(Food item) async {
    if (uid == null) return;
    await savedFoodCol.doc(item.id).set({
      ...item.toJson(),
      'savedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> unsaveFood(String id) async {
    if (uid == null) return;
    await savedFoodCol.doc(id).delete();
  }

  // --- Helpers ---

  String getWeekId(DateTime date) {
    // ✅ Sunday (7) becomes the start (index 0 for the next week)
    // Shift the date by 1 day if it's Sunday to force it into the next ISO week calculation
    final effectiveDate = date.weekday == DateTime.sunday
        ? date.add(const Duration(days: 1))
        : date;

    int dayOfYear = int.parse(DateFormat("D").format(effectiveDate));
    int woy = ((dayOfYear - effectiveDate.weekday + 10) / 7).floor();

    if (woy < 1)
      woy = 52;
    else if (woy > 52)
      woy = 1;

    return "${effectiveDate.year}_W${woy.toString().padLeft(2, '0')}";
  }

  String getDayName(DateTime date) {
    return DateFormat('EEEE').format(date).toLowerCase();
  }
}

final calaiServiceProvider = Provider((ref) => CalaiFirestoreService(ref));
