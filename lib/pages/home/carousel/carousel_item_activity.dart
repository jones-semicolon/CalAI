import 'dart:async';

import 'package:calai/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enums/food_enums.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/global_provider.dart';
import '../../../providers/entry_streams_provider.dart';
import '../../../providers/health_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CarouselActivity extends StatelessWidget {
  final int waterIntake;
  final Function(int) onWaterChange;
  final String dateId; // Changed from DateTime to String dateId

  const CarouselActivity({
    super.key,
    required this.waterIntake,
    required this.onWaterChange,
    required this.dateId,
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
                Expanded(child: _CaloriesBurnedCard(dateId: dateId)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _WaterIntakeSection(
            waterIntake: waterIntake,
            onWaterChange: onWaterChange,
          ),
        ],
      ),
    );
  }
}

// --- Private Helper Widgets --- //

class _CaloriesBurnedCard extends ConsumerWidget {
  final String dateId;

  const _CaloriesBurnedCard({required this.dateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // 1. Watch progress from the Global Provider (Replacing HealthData)
    final globalState = ref.watch(globalDataProvider).value;
    final burned = globalState?.todayProgress.caloriesBurned ?? 0;

    // 2. Watch the list of entries specifically for this date using your StreamProvider.family
    final entriesAsync = ref.watch(dailyEntriesProvider(dateId));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.splashColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBurnedHeader(theme, burned), // Extracted for readability
          const SizedBox(height: 15),

          entriesAsync.when(
            loading: () =>
                Expanded(child: const Center(child: CupertinoActivityIndicator(radius: 10))),
            error: (err, _) => const SizedBox.shrink(),
            data: (entries) {
              final exercises = entries
                  .where(
                    (data) =>
                        data.containsKey('calories_burned') &&
                        data['exercise_type'] != null &&
                        data['source'] == SourceType.exercise.value, // Safety check
                  )
                  .map((data) => ExerciseLog.fromJson(data))
                  .toList()
                  .take(3)
                  .toList();

              if (exercises.isEmpty) {
                return SizedBox.shrink();
              }

              return Column(
                children: exercises.map((ex) {
                  // ✅ FIX: Use localized labels or safe enums
                  return _ActivityItemRow(
                    title: ex.type.label,
                    value: "+${ex.caloriesBurned} kcal",
                    icon: ex.type.icon,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildBurnedHeader(ThemeData theme, int burned) {
  return Row(
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
              "$burned",
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
  );
}

class _StepsTodayCard extends ConsumerWidget {
  const _StepsTodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(stepTrackerProvider);
    final steps = ref.watch(stepsTodayProvider);

    // 2. Wrap in GestureDetector so the user can actually tap to fix permissions
    return GestureDetector(
      onTap: () => _handlePermissionRequest(context, ref),
      child: ActivityCard(
        title: "Steps Today",
        currentValue: steps,
        icon: Icons.directions_walk,
        color: Theme.of(context).colorScheme.primary, // Standard "Active" green
      ),
    );
  }

  Future<void> _handlePermissionRequest(BuildContext context, WidgetRef ref) async {
    final status = await Permission.activityRecognition.request();

    if (status.isGranted) {
      // Invalidate the stream to force a fresh hardware connection
      ref.invalidate(stepCountStreamProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Step tracking active!')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}

class _WaterIntakeSection extends StatelessWidget {
  final int waterIntake;
  final Function(int) onWaterChange;

  const _WaterIntakeSection({
    required this.waterIntake,
    required this.onWaterChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.splashColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.water_drop_outlined),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Water", style: theme.textTheme.labelSmall),
              Text(
                "$waterIntake fl oz", // Unit update
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          _ActionButton(
            icon: Icons.remove,
            onTap: () => onWaterChange(-250),
            isPrimary: false,
          ),
          const SizedBox(width: 20),
          _ActionButton(
            icon: Icons.add,
            onTap: () => onWaterChange(250),
            isPrimary: true,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.appBarTheme.foregroundColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            width: 1.5,
            color: isPrimary ? Colors.transparent : theme.splashColor,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isPrimary
              ? theme.colorScheme.onSecondary
              : theme.iconTheme.color,
        ),
      ),
    );
  }
}

// --- Shared Components ---

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
          Container(
            height: 25,
            width: 25,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
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

// ✅ 1. Change to ConsumerWidget to access 'ref'
class ActivityCard extends ConsumerWidget {
  final String title;
  final int currentValue;
  final IconData icon;
  final Color? color;

  const ActivityCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ 2. Get the user and extract the steps goal
    final user = ref.watch(userProvider);
    final int goalValue = user.goal.targets.steps;

    final double progress = (goalValue == 0) ? 0 : (currentValue / goalValue);
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor, // Sync with your other cards
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
              const SizedBox(width: 4),
              Text(
                "/$goalValue",
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant, // Better visibility
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
                      strokeWidth: 8, // Slightly thicker for a premium feel
                      strokeCap: StrokeCap.round, // Makes the progress bar look modern
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