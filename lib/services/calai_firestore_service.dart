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

      // ✅ 1. Get Clean, Nested JSON (Handles Enums & Dates automatically)
      final userData = user.toJson();

      // ✅ 2. Add Timestamp
      userData['updatedAt'] = FieldValue.serverTimestamp();

      // ✅ 3. Save Atomic
      await userDoc.set(userData, SetOptions(merge: true));

      debugPrint("✅ User saved successfully.");
    } catch (e) {
      debugPrint("❌ Error updating profile: $e");
      rethrow; // Pass error up to UI
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
      if (newTargetWeight != null) 'goal.targetWeight': newTargetWeight,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 2. Update Today's Daily Log
    batch.set(dailyLogDoc(dateKey), {
      'dailyProgress': {'weight': weight},
      if (newTargetWeight != null) 'dailyGoals': {'weightGoal': newTargetWeight},
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final Map<String, dynamic> historyUpdate = {
      'history': {
        dateKey: {
          'w': weight,
          'date': dateKey,
        },
      },
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    if (newTargetWeight != null) {
      historyUpdate['targetWeight'] = newTargetWeight;
    }

    batch.set(weightHistory, historyUpdate, SetOptions(merge: true));

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

    // 1. Update Root (Nested under goal)
    batch.update(userDoc, {
      'goal.targetWeight': weight, // ✅ Nested Correctly
      'goal.type': goalType.name, // ✅ Enum -> String
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 2. Update Today's Log
    batch.set(dailyLogDoc(todayId), {
      'goal.dailyGoals': {'weightGoal': weight},
    }, SetOptions(merge: true));

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

      dailyGoals['weightGoal'] = user.goal.targetWeight;

      if (save) {
        // We save this to 'dailyGoals' so it is easily accessible
        // AND we should also merge it into 'goal.dailyGoals' to keep the User model sync
        final batch = _db.batch();

        // 1. Root convenience field (for quick stats access)
        batch.set(userDoc, {'dailyGoals': dailyGoals}, SetOptions(merge: true));

        // 2. Nested field (for User model integrity)
        batch.set(userDoc, {
          'goal': {'dailyGoals': dailyGoals},
        }, SetOptions(merge: true));

        await batch.commit();
      }

      return UserGoal.fromJson({'dailyGoals': dailyGoals});
    }
    return null;
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
        goalData?['targetWeight'] ?? data['dailyGoals']?['weightGoal'];

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
