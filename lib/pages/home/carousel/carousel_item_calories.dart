import 'package:calai/widgets/animated_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/core/constants/constants.dart';
import '../../../enums/food_enums.dart';
import '../../../models/global_state_model.dart';
import '../../../providers/global_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/nutrition_model.dart';
import '../widgets/activity_card.dart';

class CarouselCalories extends ConsumerWidget {
  final bool isTap;
  final VoidCallback onTap;

  const CarouselCalories({
    super.key,
    required this.isTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get Today's Progress from Global State
    final globalState = ref.watch(globalDataProvider).value;
    final progress = globalState?.todayProgress ?? NutritionProgress.empty;

    // 2. Get Targets from User Model
    final user = ref.watch(userProvider);
    final targets = user.goal.targets;

    final bool isAddBurnEnabled = user.settings.isAddCalorieBurn ?? false;
    final bool isRolloverEnabled = user.settings.isRollover ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            _CaloriesCard(
              isTap: isTap,
              progress: progress,
              targets: targets,
              globalState: globalState, // ✅ Pass state to access getters
              isAddBurnEnabled: isAddBurnEnabled,
              isRolloverEnabled: isRolloverEnabled,
            ),
            const SizedBox(height: 20),
            _MacroNutrientCardsRow(
              isTap: isTap,
              progress: progress,
              targets: targets,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Private Helper Widgets --- //

class _CaloriesCard extends StatelessWidget {
  final bool isTap;
  final NutritionProgress progress;
  final NutritionGoals targets;
  final GlobalDataState? globalState;
  final bool isAddBurnEnabled;
  final bool isRolloverEnabled;

  const _CaloriesCard({
    required this.isTap,
    required this.progress,
    required this.targets,
    required this.globalState,
    required this.isAddBurnEnabled,
    required this.isRolloverEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: Theme.of(context).splashColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CalorieInfo(
            isTap: isTap,
            progress: progress,
            targets: targets,
            globalState: globalState,
            isAddBurnEnabled: isAddBurnEnabled,
            isRolloverEnabled: isRolloverEnabled,
          ),
          _CalorieProgressIndicator(
            progress: progress,
            targets: targets,
            globalState: globalState,
            isAddBurnEnabled: isAddBurnEnabled,
            isRolloverEnabled: isRolloverEnabled,
          ),
        ],
      ),
    );
  }
}

class _CalorieInfo extends StatelessWidget {
  final bool isTap;
  final NutritionProgress progress;
  final NutritionGoals targets;
  final GlobalDataState? globalState; // ✅ Add this
  final bool isAddBurnEnabled; // ✅ Add this
  final bool isRolloverEnabled;


  const _CalorieInfo({
    required this.isTap,
    required this.progress,
    required this.targets,
    required this.globalState, // ✅ Add this
    required this.isAddBurnEnabled, // ✅ Add this
    required this.isRolloverEnabled, // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    // Logic: Eaten vs Left
    final int effectiveGoal = globalState?.effectiveCalorieGoal(isAddBurnEnabled, isRolloverEnabled) ?? targets.calories;
    final int value = isTap
        ? progress.calories
        : (globalState?.caloriesRemaining(isAddBurnEnabled, isRolloverEnabled) ?? (targets.calories - progress.calories));

    final textStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.primary,
    );

    final valueString = value.abs().toString();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Wrap in AnimatedSize to make the Row expansion fluid
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.bottomLeft,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              style: textStyle,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  AnimatedSlideNumber(
                    value: valueString.isNotEmpty ? valueString.characters.first : "0",
                    style: textStyle,
                    reverse: isTap,
                  ),
                  // 2. Use AnimatedSwitcher for the rest of the number
                  if (valueString.length > 1)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        valueString.substring(1),
                        key: ValueKey(valueString), // Animate when the number changes
                      ),
                    ),
                  const SizedBox(width: 4),
                  // 3. The Goal part slides in/out smoothly
                  AnimatedSlideNumber(
                    value: isTap ? " /$effectiveGoal" : "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    reverse: isTap,
                    inAnim: false,
                  )
                ],
              ),
            ),
          ),
          // 4. Smoothly swap "eaten" and "left"
          Row(
            children: [
              Text(
                "Calories ",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              AnimatedSlideNumber(
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                value: isTap ? "eaten" : "left",
                reverse: isTap,
                inAnim: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalorieProgressIndicator extends StatelessWidget {
  final NutritionProgress progress;
  final NutritionGoals targets;
  final GlobalDataState? globalState;
  final bool isAddBurnEnabled;
  final bool isRolloverEnabled;

  const _CalorieProgressIndicator({
    required this.progress,
    required this.targets,
    required this.globalState,
    required this.isAddBurnEnabled,
    required this.isRolloverEnabled
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = globalState?.calorieProgress(isAddBurnEnabled, isRolloverEnabled) ??
        (targets.calories > 0 ? (progress.calories / targets.calories) : 0.0);

    return Center(
      child: SizedBox(
        height: 95,
        width: 95,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 95,
              width: 95,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: 0, end: progressValue),
                builder: (context, value, _) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: 7,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Theme.of(context).splashColor,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              ),
              child: const Icon(Icons.local_fire_department, size: 25),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroNutrientCardsRow extends StatelessWidget {
  final bool isTap;
  final NutritionProgress progress;
  final NutritionGoals targets;

  const _MacroNutrientCardsRow({
    required this.isTap,
    required this.progress,
    required this.targets,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CalorieCard(
            title: NutritionType.protein.label,
            nutrients: targets.protein,
            progress: progress.protein,
            color: NutritionType.protein.color,
            icon: NutritionType.protein.icon,
            unit: "g",
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: NutritionType.carbs.label,
            nutrients: targets.carbs,
            progress: progress.carbs,
            color: NutritionType.carbs.color,
            icon: NutritionType.carbs.icon,
            unit: "g",
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: NutritionType.fats.label,
            nutrients: targets.fats,
            progress: progress.fats,
            color: NutritionType.fats.color,
            icon: NutritionType.fats.icon,
            unit: "g",
            isTap: isTap,
          ),
        ),
      ],
    );
  }
}