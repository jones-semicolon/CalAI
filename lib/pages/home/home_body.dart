import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import '../../../data/global_data.dart';
import '../../../pages/home/day_item.dart';
import 'carousel/carousel_item_calories.dart';
import 'carousel/carousel_item_health.dart';
import 'carousel/carousel_item_activity.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool isTap = false;
  int calorieEaten = 200;
  int proteinEaten = 50;
  int carbsEaten = 50;
  int fatsEaten = 50;
  int fiberEaten = 12;
  int sugarEaten = 15;
  int sodiumEaten = 900;
  int currentIndex = 0;
  int waterIntakeMl = 0;

  void updateWaterIntake(int amount) {
    setState(() {
      waterIntakeMl += amount;
      if (waterIntakeMl < 0) waterIntakeMl = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Watch GlobalData to rebuild UI on API update
    final globalData = context.watch<GlobalData>();

    final carouselItems = [
      CarouselCalories(
        isTap: isTap,
        onTap: () => setState(() => isTap = !isTap),
        globalData: globalData,
        calorieEaten: calorieEaten,
        proteinEaten: proteinEaten,
        carbsEaten: carbsEaten,
        fatsEaten: fatsEaten,
      ),
      CarouselHealth(
        isTap: isTap,
        onTap: () => setState(() => isTap = !isTap),
        globalData: globalData,
        fiberEaten: fiberEaten,
        sugarEaten: sugarEaten,
        sodiumEaten: sodiumEaten,
      ),
      CarouselActivity(
        waterIntakeMl: waterIntakeMl,
        onWaterChange: updateWaterIntake,
      ),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: DayItem(),
                ),

                CarouselSlider(
                  items: carouselItems,
                  options: CarouselOptions(
                    height: 330,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, _) {
                      setState(() => currentIndex = index);
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(carouselItems.length, (index) {
                    final isActive = index == currentIndex;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? Theme.of(context).colorScheme.onPrimary
                            : Colors.transparent,
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

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Recently uploaded",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Container(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}