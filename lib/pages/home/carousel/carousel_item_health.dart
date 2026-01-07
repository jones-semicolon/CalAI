import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import '../../../data/global_data.dart';
import '../activity_card.dart';

/// A carousel item widget that displays a summary of key health metrics,
/// including cards for Fiber, Sugar, and Sodium, and a "Health Score" summary.
class CarouselHealth extends StatelessWidget {
  final bool isTap;
  final VoidCallback onTap;
  final GlobalData globalData;
  final int fiberEaten;
  final int sugarEaten;
  final int sodiumEaten;

  const CarouselHealth({
    super.key,
    required this.isTap,
    required this.onTap,
    required this.globalData,
    required this.fiberEaten,
    required this.sugarEaten,
    required this.sodiumEaten,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: onTap,
        // The main layout is a Column, now composed of cleaner, focused widgets.
        child: Column(
          children: [
            _NutrientCardsRow(
              globalData: globalData,
              fiberEaten: fiberEaten,
              sugarEaten: sugarEaten,
              sodiumEaten: sodiumEaten,
              isTap: isTap,
            ),
            // Replaced invalid `spacing` property with a standard SizedBox.
            const SizedBox(height: 10),
            const _HealthScoreCard(),
          ],
        ),
      ),
    );
  }
}

// --- Private Helper Widgets --- //

/// Displays a row of three `CalorieCard` widgets for specific nutrients.
class _NutrientCardsRow extends StatelessWidget {
  final GlobalData globalData;
  final int fiberEaten;
  final int sugarEaten;
  final int sodiumEaten;
  final bool isTap;

  const _NutrientCardsRow({
    required this.globalData,
    required this.fiberEaten,
    required this.sugarEaten,
    required this.sodiumEaten,
    required this.isTap,
  });

  @override
  Widget build(BuildContext context) {
    // This widget's structure is identical to the original implementation.
    return Row(
      children: [
        Expanded(
          child: CalorieCard(
            title: "Fiber",
            nutrients: globalData.fiberGoal,
            progress: fiberEaten,
            color: const Color.fromARGB(255, 163, 137, 211),
            icon: Icons.favorite_border,
            unit: "g",
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: "Sugar",
            nutrients: globalData.sugarGoal,
            progress: sugarEaten,
            color: const Color.fromARGB(255, 244, 143, 177),
            icon: Icons.rice_bowl,
            unit: "g",
            isTap: isTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CalorieCard(
            title: "Sodium",
            nutrients: globalData.sodiumGoal,
            progress: sodiumEaten,
            color: const Color.fromARGB(255, 231, 185, 110),
            icon: Icons.grain,
            unit: "mg",
            isTap: isTap,
          ),
        ),
      ],
    );
  }
}

/// Displays the "Health Score" card with its progress bar and summary text.
class _HealthScoreCard extends StatelessWidget {
  const _HealthScoreCard();

  @override
  Widget build(BuildContext context) {
    // This widget's structure is identical to the original implementation.
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health score',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                '0/10',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          // Replaced invalid `spacing` property with a standard SizedBox.
          const SizedBox(height: 8),
          Container(
            height: 8, // match indicator thickness
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onTertiary, // 👈 border color
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (0 / 10).clamp(0.0, 1.0),
                color: const Color.fromARGB(255, 132, 224, 125),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Carbs and fat are on track. You’re low in calories and protein, which can slow weight loss and impact muscle retention.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}