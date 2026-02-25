import 'dart:io';
import 'package:calai/providers/global_provider.dart';
import 'package:calai/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:calai/providers/shared_prefs_provider.dart';
import '../services/calai_firestore_service.dart';

final stepPermissionProvider = FutureProvider<bool>((ref) async {
  if (Platform.isAndroid) {
    return await Permission.activityRecognition.isGranted;
  } else if (Platform.isIOS) {
    return await Permission.sensors.isGranted;
  }
  return false; 
});

final stepCountStreamProvider = StreamProvider<int>((ref) async* {
  final hasPermission = await ref.watch(stepPermissionProvider.future);

  if (!hasPermission) {
    debugPrint("Step Stream Blocked: Missing permissions. Waiting for user.");
    yield* const Stream.empty();
    return;
  }

  debugPrint("✅ Step Stream Connected to Hardware.");
  yield* Pedometer.stepCountStream.map((event) => event.steps);
});

final initialStepsProvider = Provider<int>((ref) {
  final globalData = ref.watch(globalDataProvider).value;
  return (globalData?.todayProgress.steps ?? 0).round();
});

final stepsTodayProvider = StateProvider<int>((ref) => 0);
final stepTrackerProvider = Provider<void>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final service = ref.read(calaiServiceProvider);

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