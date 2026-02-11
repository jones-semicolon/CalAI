import 'package:calai/models/nutrition_model.dart';
import 'package:calai/services/calai_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../enums/food_enums.dart';
import '../models/exercise_model.dart';
import '../models/food_model.dart';
import '../models/user_model.dart';
import 'package:calai/enums/user_enums.dart';

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  // Inject the service. This keeps the Notifier "pure" and free of Ref issues.
  final service = ref.watch(calaiServiceProvider);
  return UserNotifier(service);
});

class UserNotifier extends StateNotifier<User> {
  final CalaiFirestoreService _service;

  UserNotifier(this._service) : super(_initialUser);

  // -----------------------------------------------------------------------------
  // INTERNAL HELPERS
  // -----------------------------------------------------------------------------

  /// Internal helper to update state safely.
  void _update(User Function(User state) transform) {
    state = transform(state);
  }

  // -----------------------------------------------------------------------------
  // ONBOARDING MODE (Memory Only)
  // -----------------------------------------------------------------------------

  /// USE THIS FOR ONBOARDING SCREENS.
  /// Updates the local state without hitting the database.
  /// Prevents "Ghost Users" and saves money on writes.
  void updateLocal(User Function(User state) transform) {
    state = transform(state);
  }

  /// CALL THIS AT THE END OF ONBOARDING.
  /// Flushes the entire "Draft" user to Firestore in one write.
  Future<void> completeOnboarding() async {
    try {
      debugPrint("Step 1: Calculating Goals...");

      final calculatedGoals = await _service.fetchGoals(state, forceRefresh: true, save: false);


      if (calculatedGoals != null) {
        _update((s) => s.copyWith(
          goal: s.goal.copyWith(
            targets: calculatedGoals.targets, // Only update the numbers!
          ),
        ));
      }

      debugPrint("Step 2: Saving Everything...");

      // C. THE BIG SAVE (Atomic Write)
      // Now we save Profile + Body + Goals + Settings all in ONE document write.
      await _service.updateProfile(state);

      debugPrint("Onboarding Complete & Saved!");
    } catch (e) {
      debugPrint("Onboarding Failed: $e");
      // Rethrow so the UI knows to stop the loading animation
      rethrow;
    }
  }

  void setUserGoal(UserGoal newGoal) {
    state = state.copyWith(goal: newGoal);
  }

  // -----------------------------------------------------------------------------
  // LIVE MODE (Settings & Daily Use)
  // -----------------------------------------------------------------------------

  /// Updates Name (Profile) -> Syncs to DB
  void setName(String name) async {
    final cleanName = name.trim();
    _update((s) => s.copyWith(
      profile: s.profile.copyWith(name: cleanName),
    ));
    await _service.updateUserProfileField('name', cleanName);
  }

  /// Updates Weight (Body) -> Syncs to DB
  void setWeight(double value, WeightUnit unit) async {
    if (value <= 0) return;
    // Always store as KG in the database for consistency
    double weightInKg = (unit == WeightUnit.lbs) ? value * 0.453592 : value;

    _update((s) => s.copyWith(
      body: s.body.copyWith(
        currentWeight: weightInKg,
        weightUnit: unit, // We remember their unit preference
      ),
    ));

    try {
      await _service.logWeightEntry(weightInKg);
      // Also save the unit preference
      await _service.updateUserProfileField('weightUnit', unit.value);
    } catch (e) {
      debugPrint("Failed to save weight: $e");
    }
  }

  /// Updates Height (Body) -> Syncs to DB
  void setHeight({
    required HeightUnit unit,
    double? cm,
    int? ft,
    double? inches,
  }) async {
    double finalCm = 0;
    if (unit == HeightUnit.cm) {
      finalCm = cm ?? 0;
    } else {
      finalCm = ((ft ?? 0) * 30.48) + ((inches ?? 0) * 2.54);
    }

    if (finalCm <= 0) return;

    _update((s) => s.copyWith(
      body: s.body.copyWith(height: finalCm, heightUnit: unit),
    ));

    await _service.updateUserBodyField('height', finalCm);
    await _service.updateUserProfileField('heightUnit', unit.value);
  }

  // -----------------------------------------------------------------------------
  // GOAL UPDATES (Live Sync)
  // -----------------------------------------------------------------------------

  Future<void> setTargetWeight(double target) async {
    debugPrint(target.toString());
    if (target <= 20 || target > 500) return;

    final currentWeight = state.body.currentWeight;
    Goal newGoalType = (target < currentWeight - 0.1)
        ? Goal.loseWeight
        : (target > currentWeight + 0.1) ? Goal.gainWeight : Goal.maintain;

    // 1. Update Local State
    _update((s) => s.copyWith(
      goal: s.goal.copyWith(
        targetWeight: target,
        type: newGoalType,
      ),
    ));

    try {
      // 2. Sync to Root User & Daily Logs
      await _service.updateTargetWeight(target, newGoalType);

      // 3. ✅ Sync to weight_history Document
      // This ensures your Line Graph always has the correct target line.
      await _service.logWeightEntry(currentWeight, newTargetWeight: target);

      debugPrint("✅ Goal synchronized across Master, Daily, and History.");
    } catch (e) {
      debugPrint("Failed to sync weight goal: $e");
    }
  }

  /// Sets Diet Type (e.g., Vegan) -> Syncs to DB
  void setDietType(DietType type) async {
    _update((s) => s.copyWith(
      goal: s.goal.copyWith(dietType: type),
    ));
    try {
      // DOT NOTATION: Accessing nested map inside userDoc
      await _service.userDoc.update({
        'dailyGoals.dietType': type.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Failed to sync diet type: $e");
    }
  }

  void setMaintenanceStrategy(String strategy) async {
    _update((s) => s.copyWith(
      goal: s.goal.copyWith(maintenanceStrategy: strategy),
    ));
    try {
      await _service.userDoc.update({
        'dailyGoals.maintenanceStrategy': strategy,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Failed to sync maintenance strategy: $e");
    }
  }

  /// Recalculates nutrition goals via API using current state
  Future<void> refreshNutritionGoals() async {
    final freshGoals = await _service.fetchGoals(state, forceRefresh: true);
    if (freshGoals != null) {
      _update((s) => s.copyWith(goal: freshGoals));
    }
  }

  void updateNutritionGoals(NutritionGoals newTargets) {
    state = state.copyWith(
      goal: state.goal.copyWith(
        targets: newTargets,
      ),
    );
  }

  // -----------------------------------------------------------------------------
  // LOGGING / SETTINGS
  // -----------------------------------------------------------------------------

  Future<void> deleteEntry({required String dateId, required dynamic item}) async {
    await _service.deleteLogEntry(dateId, item);
  }

  Future<void> logFoodEntry(FoodLog item, SourceType source) async {
    await _service.logFoodEntry(item, source);
  }

  Future<void> logExerciseEntry(ExerciseLog exercise) async {
    await _service.logExerciseEntry(exercise: exercise);
  }

  void setRolloverCalories(bool enable) async {
    _update((s) => s.copyWith(
      settings: s.settings.copyWith(isRollover: enable),
    ));
    await _service.updateUserSettings(state.settings);
  }

  void setAddCaloriesBurned(bool enable) async {
    _update((s) => s.copyWith(
      settings: s.settings.copyWith(isAddCalorieBurn: enable),
    ));
    await _service.updateUserSettings(state.settings);
  }
}

// -----------------------------------------------------------------------------
// DEFAULT EMPTY USER
// -----------------------------------------------------------------------------
final _initialUser = User(
  id: '',
  profile: UserProfile(
    name: "user",
    birthDate: DateTime(2001, 1, 1),
    provider: UserProvider.anonymous,
  ),
  body: UserBiometrics(
    height: 150,
    currentWeight: 70,
    heightUnit: HeightUnit.cm,
    weightUnit: WeightUnit.kg,
  ),
  goal: const UserGoal( // Ensure this matches NutritionGoals.empty
    targets: NutritionGoals.empty,
    // Add other defaults if your constructor requires them
  ),
  settings: const UserSettings(
    isAddCalorieBurn: false,
    isRollover: false,
  ),
);