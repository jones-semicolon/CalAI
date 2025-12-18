import 'package:flutter/material.dart';
import '../../../../data/global_data.dart';
import '../../../../pages/home/card1.dart';

class CarouselCalories extends StatelessWidget {
  final bool isTap;
  final VoidCallback onTap;
  final GlobalData globalData;
  final int calorieEaten;
  final int proteinEaten;
  final int carbsEaten;
  final int fatsEaten;

  const CarouselCalories({
    super.key,
    required this.isTap,
    required this.onTap,
    required this.globalData,
    required this.calorieEaten,
    required this.proteinEaten,
    required this.carbsEaten,
    required this.fatsEaten,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          spacing: 20,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isTap
                                  ? calorieEaten.toString()
                                  : (globalData.caloriesADay-calorieEaten).toString(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                              ),
                            ),
                            if (isTap)
                              Baseline(
                                baseline: 28,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  " /${globalData.caloriesADay}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Calories ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                              ),
                            ),
                            Text(
                              isTap ? "eaten" : "left",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 95,
                    width: 95,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 95,
                          width: 95,
                          child: CircularProgressIndicator(
                            value: (calorieEaten / globalData.caloriesADay)
                                .clamp(0.0, 1.0),
                            strokeWidth: 7,
                            backgroundColor: Theme.of(context).cardColor,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color:
                            Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.local_fire_department,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: CalorieCard(
                    title: "Protein",
                    nutrients: globalData.proteinADay,
                    progress: proteinEaten,
                    color: const Color.fromARGB(255, 221, 105, 105),
                    icon: Icons.set_meal_outlined,
                    unit: "g",
                    isEaten: isTap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CalorieCard(
                    title: "Carbs",
                    nutrients: globalData.carbsADay,
                    progress: carbsEaten,
                    color: const Color.fromARGB(255, 222, 154, 105),
                    icon: Icons.bubble_chart,
                    unit: "g",
                    isEaten: isTap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CalorieCard(
                    title: "Fats",
                    nutrients: globalData.fatsADay,
                    progress: fatsEaten,
                    color: const Color.fromARGB(255, 105, 152, 222),
                    icon: Icons.oil_barrel,
                    unit: "g",
                    isEaten: isTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
