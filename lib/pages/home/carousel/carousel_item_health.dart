import 'package:flutter/material.dart';
import '../../../../data/global_data.dart';
import '../../../../pages/home/card1.dart';

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
        child: Column(
          spacing: 10,
          children: [
            Row(
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
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Health score',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        '0/10',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 8, // match indicator thickness
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onTertiary, // 👈 border color
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
                  Text(
                    'Carbs and fat are on track. You’re low in calories and protein, which can slow weight loss and impact muscle retention.',
                    style: TextStyle(
                      color:
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
