import 'dart:async';

import 'package:calai/enums/user_enums.dart';
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
  final num waterIntake;
  final Function(int) onWaterChange;
  final String dateId;

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

    // 1. Watch progress from the Global Provider
    final globalState = ref.watch(globalDataProvider).value;
    final double stepsCalories = globalState?.todayProgress.caloriesBurnedPerSteps ?? 0;
    final burned = (globalState?.todayProgress.caloriesBurned ?? 0);

    // 2. Watch the list of entries specifically for this date
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
          _buildBurnedHeader(theme, burned, stepsCalories),
          const SizedBox(height: 15),

          entriesAsync.when(
            loading: () => const SizedBox(
              height: 50,
              child: Center(child: CupertinoActivityIndicator(radius: 10)),
            ),
            error: (err, _) => const SizedBox.shrink(),
            data: (entries) {
              // Extract exercise logs from database entries
              final List<ExerciseLog> exercises = entries
                  .where((data) =>
              data.containsKey('calories_burned') &&
                  data['exercise_type'] != null &&
                  data['source'] == SourceType.exercise.value)
                  .map((data) => ExerciseLog.fromJson(data))
                  .toList();

              return Column(
                children: [
                  // ✅ LOGGED STEPS:
                  // Uses the calories variable we fixed above.
                  if (stepsCalories > 0)
                    _ActivityItemRow(
                      title: "Steps",
                      // I updated 'cal' to 'kcal' to match the exercises below
                      value: "+${stepsCalories.round()} kcal",
                      icon: Icons.directions_walk,
                    ),

                  // Map the remaining exercises
                  // (take top 2 if steps exist, or 3 if not)
                  ...exercises
                      .take(stepsCalories > 0 ? 2 : 3)
                      .map((ex) => _ActivityItemRow(
                    title: ex.type.label,
                    value: "+${ex.caloriesBurned.round()} kcal",
                    icon: ex.type.icon,
                  )),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildBurnedHeader(ThemeData theme, double burned, double stepsCalories) {
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
              "${(burned + stepsCalories).round()}",
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
      // Restart both the hardware stream AND the tracker logic
      ref.invalidate(stepCountStreamProvider);
      ref.invalidate(stepTrackerProvider);

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

class _WaterIntakeSection extends ConsumerWidget {
  final num waterIntake;
  final Function(int) onWaterChange;

  const _WaterIntakeSection({
    required this.waterIntake,
    required this.onWaterChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.read(userProvider); // Get full user object
    final unitSystem = user.settings.measurementUnit;

    // Get current goal safely
    final waterGoal = ref.read(globalDataProvider).value?.todayGoal.water;

    // ✅ Define the save callback
    void onWaterGoalChange(int newWaterGoal) {
      // 1. Get current targets
      final currentTargets = user.goal.targets;

      // 2. Update just the water goal (assuming copyWith exists on your model)
      final newTargets = currentTargets.copyWith(water: newWaterGoal.toDouble());

      // 3. Call the notifier
      ref.read(userProvider.notifier).updateNutritionGoals(newTargets);
    }

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
              Row(
                children: [
                  Text(
                    // Display logic
                    "${unitSystem?.liquidToDisplay(waterIntake.toDouble()).round() ?? waterIntake.round()} ${unitSystem?.liquidLabel ?? MeasurementUnit.metric.liquidLabel}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),

                  GestureDetector(
                    onTap: () {
                      _showWaterSettings(
                        context,
                        unitSystem,
                        waterGoal?.round() ?? 2000, // Default to 2000 if null
                            (newValue) => onWaterGoalChange(newValue), // Pass the callback
                      );
                    },
                    child: Icon(Icons.settings_outlined, color: theme.colorScheme.primary, size: 16),
                  )
                ],
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

// 1. Add a callback parameter (onValueChanged) to send data back
void _showWaterSettings(
    BuildContext context,
    MeasurementUnit? unitSystem,
    int initialValue,
    ValueChanged<int> onSave, // Triggered only on close
    ) {
  // 1. Capture the value in a variable outside the builder
  int finalValue = initialValue;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      // Local state for the UI (instant updates)
      int localSelectedValue = initialValue;
      bool isPickerVisible = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDragHandle(),
                const SizedBox(height: 10),
                _buildSheetHeader(context),
                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () => setSheetState(() => isPickerVisible = !isPickerVisible),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isPickerVisible ? Colors.grey.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Serving Size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Text(
                              "$localSelectedValue ${unitSystem?.liquidLabel ?? MeasurementUnit.metric.liquidLabel}",
                              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                            ),
                            Icon(isPickerVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (isPickerVisible) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(
                        initialItem: (localSelectedValue / 100).round().clamp(0, 50),
                      ),
                      onSelectedItemChanged: (index) {
                        final newValue = index * 100;
                        setSheetState(() {
                          localSelectedValue = newValue;
                        });
                        // 2. Update our outer variable, but DO NOT save yet
                        finalValue = newValue;
                      },
                      children: List.generate(51, (index) => Center(child: Text("${index * 100}"))),
                    ),
                  ),
                ],
                const SizedBox(height: 10,),
                _buildHydrationInfo(unitSystem ?? MeasurementUnit.metric),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    // 3. This runs when the sheet is dismissed (swiped down or tapped outside)
    if (finalValue != initialValue) {
      onSave(finalValue);
    }
  });
}

// 1. Creates the small horizontal gray bar at the very top of the sheet
Widget _buildDragHandle() {
  return Center(
    child: Container(
      width: 40,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

// 2. Creates the "X" button and the "Water settings" title
Widget _buildSheetHeader(BuildContext context) {
  return Row(
    children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, size: 20, color: Colors.black54),
        ),
      ),
      const Expanded(
        child: Text(
          "Water settings",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(width: 40), // Balances the X button so title stays centered
    ],
  );
}

// Helper for the "How much water..." text section
Widget _buildHydrationInfo(MeasurementUnit measurementUnit) {
  return Column(
    children: [
      const Text(
        "How much water do you need to stay hydrated?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),
      Text(
        "Everyone's needs are slightly different, but we recommended aiming for at least ${measurementUnit.liquidToDisplay(1900).round()} ${measurementUnit.liquidLabel} (8 cups) of water each day",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
      ),
    ],
  );
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
    final num goalValue = user.goal.targets.steps;

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
                "${currentValue.round()}",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "/${goalValue.round()}",
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
