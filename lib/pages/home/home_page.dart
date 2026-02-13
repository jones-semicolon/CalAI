import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:calai/l10n/app_strings.dart';
import '../../data/global_data.dart';
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
  int currentIndex = 0;

  bool get isOverEaten {
    return calorieEaten > globalData.caloriesADay;
  }

  // --- Carousel Item 1 Content ---
  Widget _buildCarouselItem1(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onPrimary,
    );
    final calorieStatusKey =
        isTap ? 'Calories eaten' : (isOverEaten ? 'Calories over' : 'Calories left');

    Widget valueText(String text, {double fontSize = 32, Color? color}) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: textStyle.copyWith(
            fontSize: fontSize,
            color: color ?? textStyle.color,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: () => setState(() => isTap = !isTap),
        child: Column(
          children: [
            // Top Calorie Card
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
                        !isTap
                            ? isOverEaten
                                  ? valueText(
                                      "${calorieEaten - globalData.caloriesADay}g",
                                    )
                                  : valueText("${globalData.caloriesADay}g")
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  valueText(calorieEaten.toString()),
                                  const SizedBox(width: 5),
                                  valueText(
                                    '/${globalData.caloriesADay}g',
                                    fontSize: 16,
                                    color: Theme.of(
                                      context,
                                    ).secondaryHeaderColor,
                                  ),
                                ],
                              ),
                        Text(
                          context.tr(calorieStatusKey),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
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
            const SizedBox(height: 15),

            // PROTEIN / CARBS / FATS - Inner row of cards
            Row(
              children: [
                Expanded(
                  child: CalorieCard(
                    title: "Protein",
                    nutrients: globalData.proteinADay,
                    progress: proteinEaten,
                    color: const Color.fromARGB(255, 221, 105, 105),
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
                    color: const Color.fromARGB(255, 222, 154, 105),
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
                    color: const Color.fromARGB(255, 105, 152, 222),
                    icon: Icons.oil_barrel,
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

  Widget _buildCarouselItem2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: () => setState(() => isTap = !isTap),
        child: Column(
          children: [
            // FIBER / SUGAR / SODIUM - Inner row of cards
            Row(
              children: [
                Expanded(
                  child: CalorieCard(
                    title: "Fiber",
                    nutrients: globalData.fiberADay,
                    progress: proteinEaten,
                    color: const Color.fromARGB(255, 163, 137, 211),
                    icon: Icons.favorite_border,
                    isEaten: isTap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CalorieCard(
                    title: "Sugar",
                    nutrients: globalData.sugarADay,
                    progress: carbsEaten,
                    color: const Color.fromARGB(255, 244, 143, 177),
                    icon: Icons.rice_bowl,
                    isEaten: isTap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CalorieCard(
                    title: "Sodium",
                    nutrients: globalData.sodiumADay,
                    progress: fatsEaten,
                    color: const Color.fromARGB(255, 231, 185, 110),
                    icon: Icons.grain,
                    isEaten: isTap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Health Score Card
            GestureDetector(
              onTap: () {
                // Placeholder for tap action on Health Score Card
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('Health Score'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),

                          Text(
                            '0/10',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 2. Linear Progress Bar
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            value: (calorieEaten / globalData.caloriesADay)
                                .clamp(0.0, 1.0),
                            backgroundColor: Colors.transparent,
                            color: Color.fromARGB(255, 132, 224, 125),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 3. Summary Text
                      Text(
                        // Provides contextual feedback based on the current state.
                        context.tr(
                          "Carbs and fat are on track. You're low in calories and protein, which can slow weight loss and impact muscle retention.",
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSecondary,
                          height: 1.4, // Improves readability for block text
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
    );
  }

  Widget _buildCarouselItem3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          // ─────────────────────────
          // TOP ROW: Steps + Calories
          // ─────────────────────────
          Row(
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
                        color: Theme.of(context).dividerColor,
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
                                color: Theme.of(context).colorScheme.onPrimary,
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
                                ).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          context.tr("Steps Today"),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                              height: 90,
                              width: 90,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: CircularProgressIndicator(
                                      value: (1 / 2).clamp(
                                        0.0,
                                        1.0, // steps / stepsADay
                                      ),
                                      strokeWidth: 7,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).cardColor,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.directions_walk,
                                      size: 25,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
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

              const SizedBox(width: 12),

              // CALORIES BURNED
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// -------- Calories --------
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),

                              const SizedBox(width: 3),

                              Text(
                                "0",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            context.tr("Calories Burned"),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// -------- Steps --------
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
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
                                context.tr("Steps"),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
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
                                  ).colorScheme.secondary,
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
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ─────────────────────────
          // WATER INTAKE
          // ─────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),

              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// ================= LEFT SIDE =================
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.water_drop_outlined,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr("Water"),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "0 ml",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(width: 10),
                            Icon(
                              Icons.settings_outlined,
                              size: 20,
                              color: Theme.of(context).hintColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                /// ================= RIGHT SIDE =================
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.remove, size: 20),
                    ),

                    const SizedBox(width: 20),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onPrimary,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 2,
                        ),
                      ),

                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [
      _buildCarouselItem1(context),
      _buildCarouselItem2(context),
      _buildCarouselItem3(context),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        // === LARGE SCREEN FIX APPLIED HERE ===
        child: Center(
          // Limits the maximum width of the content column for tablet/desktop
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700, // A comfortable reading width for dashboards
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Day Item
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: DayItem(),
                ),

                /// 2. CAROUSEL SLIDER
                CarouselSlider(
                  items: carouselItems,
                  options: CarouselOptions(
                    height: 340.0,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),

                /// 3. BULLET INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(carouselItems.length, (index) {
                    bool isActive = index == currentIndex;
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

                // 4. Section Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.tr("Recently uploaded"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),

                /// 5. BOTTOM CONTENT
                Container(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
