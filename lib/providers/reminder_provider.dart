import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/reminders/services/reminder_bootstrap.dart';
import '../models/nutrition_model.dart';
import 'global_provider.dart';

final reminderSyncProvider = Provider<void>((ref) {
  // 1. Keep the provider alive
  ref.keepAlive();

  // 2. Local variable to prevent rapid fire
  DateTime? lastSync;

  Future<void> sync(NutritionGoals goals) async {
    // Only sync if goals have actually changed or enough time has passed (e.g., 5 seconds)
    final now = DateTime.now();
    if (lastSync != null && now.difference(lastSync!).inSeconds < 5) return;

    lastSync = now;

    await ReminderBootstrap.initializeIfNeeded(goals: goals);
    debugPrint("🔔 Reminders Synced");
  }

  // 3. Listen to the data instead of watching it
  ref.listen(globalDataProvider, (previous, next) {
    final goals = next.value?.todayGoal;

    if (goals != null) {
      sync(NutritionGoals(
        calories: goals.calories,
        protein: goals.protein,
        carbs: goals.carbs,
        fats: goals.fats,
      ));
    }
  });

  // 4. Handle Lifecycle
  final observer = _ReminderLifecycleObserver(onResume: () async {
    final currentGoals = ref.read(globalDataProvider).value?.todayGoal;
    if (currentGoals != null) {
      // Manual trigger on resume
      ReminderBootstrap.initializeIfNeeded(
        goals: NutritionGoals(
          calories: currentGoals.calories,
          protein: currentGoals.protein,
          carbs: currentGoals.carbs,
          fats: currentGoals.fats,
        ),
      );
    }
  });

  WidgetsBinding.instance.addObserver(observer);
  ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
});

class _ReminderLifecycleObserver extends WidgetsBindingObserver {
  final Future<void> Function() onResume;
  _ReminderLifecycleObserver({required this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // We don't await here because this method is synchronous,
      // but the callback itself is a Future.
      onResume();
    }
  }
}