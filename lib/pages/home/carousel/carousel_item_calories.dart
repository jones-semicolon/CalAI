import 'package:calai/widgets/animated_number.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import '../../../data/health_data.dart';
import '../widgets/activity_card.dart'; // Import the new State

class CarouselCalories extends StatelessWidget {
  final bool isTap;
  final VoidCallback onTap;
  final HealthData health; // Rely on HealthData state

  const CarouselCalories({
    super.key,
    required this.isTap,
    required this.onTap,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            _CaloriesCard(
              isTap: isTap,
              health: health,
            ),
            const SizedBox(height: 20),
            _MacroNutrientCardsRow(
              isTap: isTap,
              health: health,
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
  final HealthData health;

  const _CaloriesCard({
    required this.isTap,
    required this.health,
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
            health: health,
          ),
          _CalorieProgressIndicator(
            health: health,
          ),
        ],
      ),
    );
  }
}

class _CalorieInfo extends StatelessWidget {
  final bool isTap;
  final HealthData health;

  const _CalorieInfo({
    required this.isTap,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    // Logic for "calories left" vs "eaten"
    final int value = isTap ? health.dailyIntake : (health.calorieGoal - health.dailyIntake);


    final textStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.primary,
    );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  AnimatedSlideNumber(
                    value: value.toString().split("").first,
                    style: textStyle,
                    reverse: isTap,
                  ),
                  Text(
                    value.toString().split("").sublist(1).join(),
                    style: textStyle,
                  )
                ],
              ),
              Baseline(
                baseline: 28,
                baselineType: TextBaseline.alphabetic,
                child: AnimatedSlideNumber(
                  value: isTap ? " /${health.calorieGoal}" : "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  reverse: isTap,
                  inAnim: false,
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "Calories ",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                isTap ? "eaten" : "left",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalorieProgressIndicator extends StatelessWidget {
  final HealthData health;

  const _CalorieProgressIndicator({
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    // Avoid division by zero
    final double progressValue = health.calorieGoal > 0
        ? (health.dailyIntake / health.calorieGoal).clamp(0.0, 1.0)
        : 0.0;

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
                tween: Tween<double>(
                  begin: 0,
                  end: progressValue,
                ),
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
              child: const Icon(
                Icons.local_fire_department,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroNutrientCardsRow extends StatelessWidget {
  final bool isTap;
  final HealthData health;

  const _MacroNutrientCardsRow({
    required this.isTap,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CalorieCard(
            title: "Protein",
            nutrients: health.proteinGoal,
            progress: health.dailyProtein,
            color: const Color.fromARGB(255, 221, 105, 105),
            icon: Icons.egg_alt,
            unit: "g",
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: "Carbs",
            nutrients: health.carbsGoal,
            progress: health.dailyCarbs,
            color: const Color.fromARGB(255, 222, 154, 105),
            icon: Icons.rice_bowl,
            unit: "g",
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: "Fats",
            nutrients: health.fatsGoal,
            progress: health.dailyFats,
            color: const Color.fromARGB(255, 105, 152, 222),
            icon: Icons.fastfood,
            unit: "g",
            isTap: isTap,
          ),
        ),
      ],
    );
  }
}