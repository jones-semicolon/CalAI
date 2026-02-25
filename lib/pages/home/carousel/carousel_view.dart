import 'package:flutter/material.dart'; // Changed from cupertino to material for standard Curves
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/page_indicator.dart';
import 'carousel_item_activity.dart';
import 'carousel_item_calories.dart';
import 'carousel_item_health.dart';
import '../../../providers/global_provider.dart'; // Import to get activeDateId

const double _carouselHeight = 330;

class CarouselView extends ConsumerStatefulWidget {
  final bool isTap;
  final int currentIndex;
  final VoidCallback onTap;
  final void Function(int) onWaterChange;
  final void Function(int) onPageChanged;
  final DateTime date;

  const CarouselView({
    super.key,
    required this.isTap,
    required this.onTap,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onWaterChange,
    required this.date,
  });

  @override
  ConsumerState<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends ConsumerState<CarouselView> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.currentIndex);
  }

  @override
  void didUpdateWidget(CarouselView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.hasClients &&
        widget.currentIndex != oldWidget.currentIndex &&
        widget.currentIndex != _controller.page?.round()) {
      _controller.animateToPage(
        widget.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    // ✅ FIX 1: Only watch the specific data needed for this level (the ID)
    // This prevents a rebuild of the whole Carousel if water/calories change!
    final activeDateId = ref.watch(globalDataProvider.select((async) => async.value?.activeDateId ?? ''));

    // ✅ FIX 2: Watch water separately using select
    final currentWater = ref.watch(globalDataProvider.select((async) => async.value?.todayProgress.water ?? 0));

    final pages = [
      CarouselCalories(
        key: const ValueKey('calories_page'), // ✅ FIX 3: Add Stable Keys
        isTap: widget.isTap,
        onTap: widget.onTap,
      ),
      CarouselHealth(
        key: const ValueKey('health_page'), // ✅ FIX 3: Add Stable Keys
        isTap: widget.isTap,
        onTap: widget.onTap,
      ),
      CarouselActivity(
        key: const ValueKey('activity_page'), // ✅ FIX 3: Add Stable Keys
        waterIntake: currentWater,
        onWaterChange: widget.onWaterChange,
        dateId: activeDateId,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _carouselHeight,
          child: PageView(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            onPageChanged: widget.onPageChanged,
            allowImplicitScrolling: false,
            children: pages,
          ),
        ),
        const SizedBox(height: 8),
        PageIndicator(
          count: pages.length,
          activeIndex: widget.currentIndex,
        ),
      ],
    );
  }
}