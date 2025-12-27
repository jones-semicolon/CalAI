import 'package:calai/widgets/animated_number.dart';
import 'package:flutter/material.dart';
import '../../../../data/global_data.dart';
import '../../../../pages/home/card1.dart';

class CarouselCalories extends StatelessWidget {
  final bool isTap;
  final VoidCallback onTap;
  final GlobalData globalData;
  final int calorieTaken;
  final int proteinTaken;
  final int carbsTaken;
  final int fatsTaken;

  const CarouselCalories({
    super.key,
    required this.isTap,
    required this.onTap,
    required this.globalData,
    required this.calorieTaken,
    required this.proteinTaken,
    required this.carbsTaken,
    required this.fatsTaken,
  });

  @override
  Widget build(BuildContext context) {
    final int value = isTap
        ? calorieTaken
        : (globalData.calorieGoal - calorieTaken);
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
                  color: Theme.of(context).splashColor,
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
                            Row(
                              children: [
                                AnimatedSlideNumber(
                                  value: value.toString().split("").first,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  reverse: isTap,
                                ),
                                Text(
                                  value.toString().split("").sublist(1).join(),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                            Baseline(
                              baseline: 28,
                              baselineType: TextBaseline.alphabetic,
                              child: AnimatedSlideNumber(
                                value: isTap ? " /${globalData.calorieGoal}" : "",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
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
                  ),
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
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                              tween: Tween<double>(
                                begin: 0,
                                end: (calorieTaken / globalData.calorieGoal).clamp(0.0, 1.0),
                              ),
                              builder: (context, value, _) => CircularProgressIndicator(
                                value: value,
                                strokeWidth: 7,
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
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: CalorieCard(
                    title: "Protein",
                    nutrients: globalData.proteinGoal,
                    progress: proteinTaken,
                    color: const Color.fromARGB(255, 221, 105, 105),
                    icon: Icons.set_meal_outlined,
                    unit: "g",
                    isTap: isTap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CalorieCard(
                    title: "Carbs",
                    nutrients: globalData.carbsGoal,
                    progress: carbsTaken,
                    color: const Color.fromARGB(255, 222, 154, 105),
                    icon: Icons.bubble_chart,
                    unit: "g",
                    isTap: isTap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CalorieCard(
                    title: "Fats",
                    nutrients: globalData.fatsGoal,
                    progress: fatsTaken,
                    color: const Color.fromARGB(255, 105, 152, 222),
                    icon: Icons.oil_barrel,
                    unit: "g",
                    isTap: isTap,
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
