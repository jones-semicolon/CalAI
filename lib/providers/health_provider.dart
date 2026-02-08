// Exposes the real-time step count from the device hardware
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/calai_firestore_service.dart';


final stepCountStreamProvider = StreamProvider<int>((ref) {
  // Pedometer.stepCountStream returns a StepCount object; we map it to just the integer
  return Pedometer.stepCountStream.map((event) => event.steps);
});

final stepsTodayProvider = StateProvider<int>((ref) => 0);

// We use the StreamProvider as the trigger to update our calculated state
final stepTrackerProvider = Provider<void>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final service = ref.read(calaiServiceProvider); // ✅ Access Firestore service

  ref.listen<AsyncValue<int>>(stepCountStreamProvider, (previous, next) {
    next.whenData((totalSteps) {
      final String todayKey = "steps_baseline_${DateTime.now().toIso8601String().substring(0, 10)}";
      int? baseline = prefs.getInt(todayKey);

      if (baseline == null || totalSteps < baseline) {
        prefs.setInt(todayKey, totalSteps);
        baseline = totalSteps;
      }

      final int stepsToday = totalSteps - baseline;

      // 1. Update Local UI State
      ref.read(stepsTodayProvider.notifier).state = stepsToday;

      // 2. ✅ Sync to Firestore (Use a small debounce if walking fast to save writes)
      service.syncSteps(stepsToday);
    });
  });
});

// This provider will hold the instance of SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // We will override this in main.dart
});