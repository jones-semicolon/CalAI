import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STEPS TODAY
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO:
                    // Request Google Fit permission
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
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
                              "5000", // stepsCount
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "/10000", // stepsAday
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary,
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
                        const SizedBox(height: 10),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
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
                                      value: (1 / 2).clamp(
                                        0.0,
                                        1.0, // steps / stepsADay
                                      ),
                                      strokeWidth: 7,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).splashColor,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).cardColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.directions_walk,
                                      size: 25,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // CALORIES BURNED
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).splashColor,
                      width: 1,
                    ),
                  ),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 7.5,
                              ),
                              child: Icon(
                                Icons.local_fire_department,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    "Calories Burned",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
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
                        SizedBox(height: 80)
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.water_drop_outlined),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Water",
                        style: Theme.of(context).textTheme.labelSmall),
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
                        // color: Theme.of(context).appBarTheme.foregroundColor,
                        borderRadius: BorderRadius.circular(50),
                        border: BoxBorder.all(width: 1.5)
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      // color: Theme.of(context).colorScheme.primary,
                    ),
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
                        border: BoxBorder.all(width: 1.5)
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
          ),
        ],
      ),
    );
  }
}
