
// ------------------------------------------------------------
// CAROUSEL VIEW (PageView)
// ------------------------------------------------------------


import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/health_data.dart';
import '../widgets/page_indicator.dart';
import 'carousel_item_activity.dart';
import 'carousel_item_calories.dart';
import 'carousel_item_health.dart';

const double _carouselHeight = 330;

class CarouselView extends ConsumerStatefulWidget {
  final bool isTap;
  final int currentIndex;
  final VoidCallback onTap;
  final void Function(int) onWaterChange;
  final void Function(int) onPageChanged;

  const CarouselView({
    super.key,
    required this.isTap,
    required this.onTap,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onWaterChange,
  });

  @override
  ConsumerState<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends ConsumerState<CarouselView> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize with the current index from the parent
    _controller = PageController(initialPage: widget.currentIndex);
  }

  @override
  void didUpdateWidget(CarouselView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ✅ CRITICAL: If the parent forces a new index, update the controller.
    // We check if the controller is attached and if the page is actually different.
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
  Widget build(BuildContext context) {
    // Watching the provider here ensures the cards update in real-time
    final health = ref.watch(healthDataProvider);

    final pages = [
      CarouselCalories(
        isTap: widget.isTap,
        onTap: widget.onTap,
        health: health,
      ),
      CarouselHealth(
        isTap: widget.isTap,
        onTap: widget.onTap,
        health: health,
      ),
      CarouselActivity(
        waterIntake: health.dailyWater,
        onWaterChange: widget.onWaterChange,
        health: health,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min, // Optimization: only take needed space
      children: [
        SizedBox(
          height: _carouselHeight,
          child: PageView(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            onPageChanged: widget.onPageChanged,
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