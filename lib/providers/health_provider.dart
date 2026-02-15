// Exposes the real-time step count from the device hardware
import 'package:calai/providers/global_provider.dart';
import 'package:calai/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/calai_firestore_service.dart';


final stepCountStreamProvider = StreamProvider<int>((ref) {
  // Pedometer.stepCountStream returns a StepCount object; we map it to just the integer
  return Pedometer.stepCountStream.map((event) => event.steps);
});

final initialStepsProvider = Provider<int>((ref) {
  // Watch the global data. If it's loading, this will return 0 initially.
  final globalData = ref.watch(globalDataProvider).value;

  // Return the steps from your existing todayProgress
  return (globalData?.todayProgress.steps ?? 0) as int;
});

final stepsTodayProvider = StateProvider<int>((ref) => 0);

// We use the StreamProvider as the trigger to update our calculated state
final stepTrackerProvider = Provider<void>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final service = ref.read(calaiServiceProvider); // ✅ Access Firestore service

  ref.listen<int>(initialStepsProvider, (previous, next) {
    final currentLocal = ref.read(stepsTodayProvider);
    // If our live state is 0 but the DB has data, hydrate it
    if (next > currentLocal) {
      ref.read(stepsTodayProvider.notifier).state = next;
    }
  });

  ref.listen<AsyncValue<int>>(stepCountStreamProvider, (previous, next) {
    next.whenData((totalSteps) {
      final String todayKey = "steps_baseline_${DateTime.now().toIso8601String().substring(0, 10)}";
      int? baseline = prefs.getInt(todayKey);

      if (baseline == null || totalSteps < baseline) {
        // If this is the first time opening the app today,
        // we calculate baseline such that (totalSteps - baseline) == DB steps
        final int dbSteps = ref.read(stepsTodayProvider);
        baseline = totalSteps - dbSteps;
        prefs.setInt(todayKey, baseline);
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