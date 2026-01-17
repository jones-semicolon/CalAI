import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import '../../data/global_data.dart';
import '../../data/health_data.dart';
import 'day_item.dart';
import 'carousel/carousel_item_calories.dart';
import 'carousel/carousel_item_health.dart';
import 'carousel/carousel_item_activity.dart';

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  bool _isTap = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final globalAsync = ref.watch(globalDataProvider);
    final health = ref.watch(healthDataProvider);

    return globalAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
      data: (global) {
        // optional: if you still track "isInitialized"
        if (!global.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DayItem(
                      progressDays: global.progressDays,
                      overDays: global.overDays,
                      dailyCalories: global.dailyCalories,
                      calorieGoal: global.calorieGoal,
                      selectedDateId: global.activeDateId,
                      onDaySelected: (dateId) =>
                          ref.read(globalDataProvider.notifier).selectDay(dateId),
                    ),
                  ),

                  _CarouselView(
                    isTap: _isTap,
                    onTap: () => setState(() => _isTap = !_isTap),
                    health: health,
                    onWaterChange: (amount) {
                      // ✅ if you want this to save to firestore, call global notifier here
                      // ref.read(globalDataProvider.notifier).updateWater(amount);
                    },
                    currentIndex: _currentIndex,
                    onPageChanged: (index, _) =>
                        setState(() => _currentIndex = index),
                  ),

                  const SizedBox(height: 30),
                  const _RecentlyUploadedSection(),
                  Container(height: 300),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A private widget to encapsulate the Carousel and its indicator dots.
class _CarouselView extends StatelessWidget {
  final bool isTap;
  final int currentIndex;
  final HealthData health;

  final VoidCallback onTap;
  final void Function(int) onWaterChange;
  final void Function(int, CarouselPageChangedReason) onPageChanged;

  const _CarouselView({
    required this.isTap,
    required this.onTap,
    required this.currentIndex,
    required this.onPageChanged,
    required this.health,
    required this.onWaterChange,
  });

  @override
  Widget build(BuildContext context) {
    final carouselItems = <Widget>[
      CarouselCalories(
        isTap: isTap,
        onTap: onTap,
        health: health,
      ),
      CarouselHealth(
        isTap: isTap,
        onTap: onTap,
        health: health,
      ),
      CarouselActivity(
        waterIntakeMl: health.dailyWater,
        onWaterChange: onWaterChange,
      ),
    ];

    return Column(
      children: [
        CarouselSlider(
          items: carouselItems,
          options: CarouselOptions(
            height: 330,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: onPageChanged,
          ),
        ),
        const SizedBox(height: 8),
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
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: 1.5,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _RecentlyUploadedSection extends StatelessWidget {
  const _RecentlyUploadedSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Recently uploaded",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
