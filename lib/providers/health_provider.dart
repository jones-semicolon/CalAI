// Exposes the real-time step count from the device hardware
import 'package:calai/providers/global_provider.dart';
import 'package:calai/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:calai/providers/shared_prefs_provider.dart'; // ✅ Use this import

import '../services/calai_firestore_service.dart';


final stepCountStreamProvider = StreamProvider<int>((ref) {
  // Pedometer.stepCountStream returns a StepCount object; we map it to just the integer
  return Pedometer.stepCountStream.map((event) => event.steps);
});

final initialStepsProvider = Provider<int>((ref) {
  // Watch the global data. If it's loading, this will return 0 initially.
  final globalData = ref.watch(globalDataProvider).value;

  // Return the steps from your existing todayProgress
  return (globalData?.todayProgress.steps ?? 0).round();
});

final stepsTodayProvider = StateProvider<int>((ref) => 0);

// We use the StreamProvider as the trigger to update our calculated state
final stepTrackerProvider = Provider<void>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final service = ref.read(calaiServiceProvider);

  // 1. Watch the user provider so we always have the latest weight
  final user = ref.watch(userProvider);

  ref.listen<int>(initialStepsProvider, (previous, next) {
    final currentLocal = ref.read(stepsTodayProvider);
    if (next > currentLocal) {
      ref.read(stepsTodayProvider.notifier).state = next;
    }
  });

  ref.listen<AsyncValue<int>>(stepCountStreamProvider, (previous, next) {
    next.whenData((totalSteps) {
      final String todayKey = "steps_baseline_${DateTime.now().toIso8601String().substring(0, 10)}";
      int? baseline = prefs.getInt(todayKey);

      if (baseline == null || totalSteps < baseline) {
        final int dbSteps = ref.read(stepsTodayProvider);
        baseline = totalSteps - dbSteps;
        prefs.setInt(todayKey, baseline);
      }

      final int stepsToday = totalSteps - baseline;
      final int lastSyncedSteps = ref.read(stepsTodayProvider);

      // ✅ OPTIMIZATION: Only sync to Firestore if steps actually increased
      if (stepsToday != lastSyncedSteps) {
        ref.read(stepsTodayProvider.notifier).state = stepsToday;

        service.syncSteps(
          stepsToday,
          currentWeight: user?.body.currentWeight
        );
      }
    });
  });
});