import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

/// A carousel item widget that displays user activity metrics, including
/// daily steps, calories burned, and a water intake logger.
class CarouselActivity extends StatelessWidget {
  final int waterIntakeMl;
  final Function(int) onWaterChange;

  const CarouselActivity({
    super.key,
    required this.waterIntakeMl,
    required this.onWaterChange,
  });

  @override
  Widget build(BuildContext context) {
    // The main layout is a Column, now composed of smaller, focused widgets.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: _StepsTodayCard()),
              SizedBox(width: 10),
              Expanded(child: _CaloriesBurnedCard()),
            ],
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

/// A card displaying the user's step count for the day against their goal.
class _StepsTodayCard extends StatelessWidget {
  const _StepsTodayCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Request Google Fit permission
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(
            color: Theme.of(context).splashColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "5000",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "/10000",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              "Steps Today",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
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
                        value: 0.5,
                        strokeWidth: 7,
                        backgroundColor: Theme.of(context).splashColor,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.directions_walk,
                        size: 25,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

/// A card displaying the user's estimated calories burned from activity.
class _CaloriesBurnedCard extends StatelessWidget {
  const _CaloriesBurnedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: Theme.of(context).splashColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                child: Icon(
                  Icons.local_fire_department,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "Calories Burned",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.battery_std,
                  size: 14,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Steps",
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "+0",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 80)
        ],
      ),
    );
  }
}

/// A section for logging water intake with increment and decrement buttons.
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
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => onWaterChange(-250),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 1.5),
              ),
              child: const Icon(Icons.remove, size: 20),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () => onWaterChange(250),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.foregroundColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 1.5),
              ),
              child: Icon(
                Icons.add,
                size: 20,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          )
        ],
      ),
    );
  }
}