import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart'; // <--- REMOVE THIS LINE TO AVOID ERRORS

import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import '../../data/global_data.dart';
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
  // --- STATE VARIABLES --- //
  bool _isTap = false;
  int _currentIndex = 0;

  // --- MOCK DATA --- //
  int _calorieTaken = 300;
  int _proteinTaken = 50;
  int _carbsTaken = 50;
  int _fatsTaken = 50;
  int _fiberEaten = 12;
  int _sugarEaten = 15;
  int _sodiumEaten = 900;
  int _waterIntakeMl = 0;

  void _updateWaterIntake(int amount) {
    setState(() {
      _waterIntakeMl = (_waterIntakeMl + amount).clamp(0, double.infinity).toInt();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This works correctly now!
      ref.read(globalDataProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- FIX IS HERE ---
    // OLD (Crash): final globalData = context.watch<GlobalData>();
    // NEW (Correct):
    final globalData = ref.watch(globalDataProvider);

    return SingleChildScrollView(
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

              _CarouselView(
                isTap: _isTap,
                onTap: () => setState(() => _isTap = !_isTap),
                globalData: globalData,
                calorieTaken: _calorieTaken,
                proteinTaken: _proteinTaken,
                carbsTaken: _carbsTaken,
                fatsTaken: _fatsTaken,
                fiberEaten: _fiberEaten,
                sugarEaten: _sugarEaten,
                sodiumEaten: _sodiumEaten,
                waterIntakeMl: _waterIntakeMl,
                onWaterChange: _updateWaterIntake,
                currentIndex: _currentIndex,
                onPageChanged: (index, _) => setState(() => _currentIndex = index),
              ),

              const SizedBox(height: 30),

              const _RecentlyUploadedSection(),

              Container(height: 300),
            ],
          ),
        ),
      ),
    );
  }
}

// ... The rest of your classes (_CarouselView, etc.) remain exactly the same ...
// ... Copy them from your previous message ...

/// A private widget to encapsulate the Carousel and its indicator dots.
class _CarouselView extends StatelessWidget {
  // State from parent
  final bool isTap;
  final GlobalData globalData;
  final int calorieTaken, proteinTaken, carbsTaken, fatsTaken;
  final int fiberEaten, sugarEaten, sodiumEaten;
  final int waterIntakeMl;
  final int currentIndex;

  // Callbacks
  final VoidCallback onTap;
  final void Function(int) onWaterChange;
  final void Function(int, CarouselPageChangedReason) onPageChanged;

  const _CarouselView({
    required this.isTap,
    required this.onTap,
    required this.globalData,
    required this.calorieTaken,
    required this.proteinTaken,
    required this.carbsTaken,
    required this.fatsTaken,
    required this.fiberEaten,
    required this.sugarEaten,
    required this.sodiumEaten,
    required this.waterIntakeMl,
    required this.onWaterChange,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> carouselItems = [
      CarouselCalories(
        isTap: isTap,
        onTap: onTap,
        globalData: globalData,
        calorieTaken: calorieTaken,
        proteinTaken: proteinTaken,
        carbsTaken: carbsTaken,
        fatsTaken: fatsTaken,
      ),
      CarouselHealth(
        isTap: isTap,
        onTap: onTap,
        globalData: globalData,
        fiberEaten: fiberEaten,
        sugarEaten: sugarEaten,
        sodiumEaten: sodiumEaten,
      ),
      CarouselActivity(
        waterIntakeMl: waterIntakeMl,
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
        // Carousel indicator dots
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