import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:calai/data/global_data.dart';
import 'card1.dart';
import 'day_item.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final globalData = GlobalData();

  bool isTap = false;

  int calorieEaten = 50;
  int proteinEaten = 50;
  int carbsEaten = 50;
  int fatsEaten = 50;

  int currentIndex = 0; // FOR BULLET INDICATOR

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [
      /// ---------------- FIRST ITEM ----------------
      Offstage(
        offstage: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: GestureDetector(
            onTap: () => setState(() => isTap = !isTap),
            child: Column(
              children: [
                /// CALORIE CARD
                Container(
                  padding: EdgeInsets.all(20),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTap
                                ? "$calorieEaten /${globalData.caloriesADay}"
                                : globalData.caloriesADay.toString(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Calories ${isTap ? 'eaten' : 'left'}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),

                      /// Circular Progress
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
                                color: Theme.of(context).colorScheme.secondary,
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

                const SizedBox(height: 20),

                /// PROTEIN / CARBS / FATS
                Row(
                  children: [
                    Expanded(
                      child: CalorieCard(
                        title: "Protein",
                        nutrients: globalData.proteinADay,
                        progress: proteinEaten,
                        color: Color.fromARGB(255, 221, 105, 105),
                        icon: Icons.set_meal_outlined,
                        isEaten: isTap,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CalorieCard(
                        title: "Carbs",
                        nutrients: globalData.carbsADay,
                        progress: carbsEaten,
                        color: Color.fromARGB(255, 222, 154, 105),
                        icon: Icons.bubble_chart,
                        isEaten: isTap,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CalorieCard(
                        title: "Fats",
                        nutrients: globalData.fatsADay,
                        progress: fatsEaten,
                        color: Color.fromARGB(255, 105, 152, 222),
                        icon: Icons.oil_barrel,
                        isEaten: isTap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      /// ---------------- SECOND ITEM -----------------
      const Center(
        child: Text("Second Item Placeholder", style: TextStyle(fontSize: 20)),
      ),

      /// ---------------- THIRD ITEM -----------------
      const Center(
        child: Text("Third Item Placeholder", style: TextStyle(fontSize: 20)),
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: DayItem(),
            ), // NEW DAY ITEM WIDGET
            /// ============ CAROUSEL ============
            CarouselSlider(
              items: carouselItems,
              options: CarouselOptions(
                height: 310,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            /// ============ BULLET INDICATOR ============
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(carouselItems.length, (index) {
                bool isActive = index == currentIndex;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).appBarTheme.backgroundColor,
                    border: Border.all(
                      color: isActive
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Recently uploaded",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Container(height: 400),
          ],
        ),
      ),
    );
  }
}
