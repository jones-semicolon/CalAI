import 'package:calai/data/health_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart'; // ✅ Required for Google Fit / HealthKit
import 'package:permission_handler/permission_handler.dart'; // Import this

import '../../../api/exercise_api.dart';
import '../../../data/global_data.dart';
import '../../../services/health_providers.dart';

class CarouselActivity extends StatelessWidget {
  final int waterIntakeMl;
  final HealthData health;
  final Function(int) onWaterChange;

  const CarouselActivity({
    super.key,
    required this.waterIntakeMl,
    required this.onWaterChange,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(child: _StepsTodayCard()),
                const SizedBox(width: 10),
                Expanded(child: _CaloriesBurnedCard(health: health)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _WaterIntakeSection(
            waterIntakeMl: waterIntakeMl,
            onWaterChange: onWaterChange,
          ),
        ],
      ),
    );
  }
}

// --- Private Helper Widgets --- //
class _StepsTodayCard extends ConsumerWidget {
  const _StepsTodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepsAsync = ref.watch(stepsTodayProvider);

    return GestureDetector(
      onTap: () => ref.refresh(stepsTodayProvider),
      child: stepsAsync.when(
        loading: () => const ActivityCard(
          title: "Steps Today",
          currentValue: 0,
          goalValue: 10000,
          icon: Icons.directions_walk,
        ),
        error: (e, _) => ActivityCard(
          title: "Steps Today",
          currentValue: 0,
          goalValue: 10000,
          icon: Icons.directions_walk,
        ),
        data: (steps) => ActivityCard(
          title: "Steps Today",
          currentValue: steps,
          goalValue: 10000,
          icon: Icons.directions_walk,
        ),
      ),
    );
  }
}

class _ActivityItemRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ActivityItemRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // 1. Black Circle Icon
          Container(
            height: 25,
            width: 25,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),

          // 2. Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaloriesBurnedCard extends ConsumerWidget {
  final HealthData health;

  const _CaloriesBurnedCard({required this.health});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = DateTime.now().toIso8601String().split('T').first;

    final entriesStream = ref
        .read(globalDataProvider.notifier)
        .watchEntries(today);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.splashColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                child: Icon(
                  Icons.local_fire_department,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      health.dailyBurned.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "Calories Burned",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          // Stream Builder for Logs
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: entriesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final exercises = snapshot.data!
                  .where((data) => data.containsKey('caloriesBurned'))
                  .map((data) {
                return Exercise(
                  id: data['id']?.toString() ?? '',
                  type: data['exerciseType'] ?? 'Exercise',
                  intensity: Intensity.fromString(
                    data['intensity'] ?? 'Low',
                  ),
                  durationMins: (data['durationMins'] ?? 0) as int,
                  caloriesBurned: (data['caloriesBurned'] ?? 0).toInt(),
                  timestamp: data['timestamp'] != null
                      ? (data['timestamp'] as dynamic).toDate()
                      : DateTime.now(),
                );
              })
                  .take(3)
                  .toList();

              if (exercises.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "",
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.disabledColor,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: exercises
                    .map(
                        (ex) => _ActivityItemRow(
                      title: ExerciseType.fromString(ex.type).label,
                      value: "+${ex.caloriesBurned}",
                      icon: ExerciseType.fromString(ex.type).icon,
                    )
                )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WaterIntakeSection extends StatelessWidget {
  final int waterIntakeMl;
  final Function(int) onWaterChange;

  const _WaterIntakeSection({
    required this.waterIntakeMl,
    required this.onWaterChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).splashColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.water_drop_outlined),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Water", style: Theme.of(context).textTheme.labelSmall),
              Text(
                "$waterIntakeMl ml",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          // Decrement
          GestureDetector(
            onTap: () => onWaterChange(-250),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  width: 1.5,
                  color: Theme.of(context).splashColor,
                ),
              ),
              child: const Icon(Icons.remove, size: 20),
            ),
          ),
          const SizedBox(width: 20),
          // Increment
          GestureDetector(
            onTap: () => onWaterChange(250),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.foregroundColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 1.5, color: Colors.transparent),
              ),
              child: Icon(
                Icons.add,
                size: 20,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Reusable Activity Card --- //

class ActivityCard extends StatelessWidget {
  final String title;
  final int currentValue;
  final int goalValue;
  final IconData icon;
  final Color? color;

  const ActivityCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.goalValue,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (goalValue == 0) ? 0 : (currentValue / goalValue);
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.splashColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "$currentValue",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "/$goalValue",
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(title, style: TextStyle(color: primaryColor, fontSize: 12)),
          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              height: 95,
              width: 95,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 95,
                    width: 95,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 7,
                      backgroundColor: theme.splashColor,
                      color: primaryColor,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 25, color: primaryColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}