import 'package:calai/pages/home/recently_logged/log_card.dart';
import 'package:calai/pages/home/recently_logged/recently_logged_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide CarouselView;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calai/api/exercise_api.dart';
import 'package:calai/api/food_api.dart';

import '../../data/global_data.dart';

import '../../models/food.dart';
import 'calendar/day_item.dart';
import  'carousel/carousel_view.dart';

const double _maxContentWidth = 700;

// ------------------------------------------------------------
// HOME BODY
// ------------------------------------------------------------

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> with AutomaticKeepAliveClientMixin {
  bool _isTap = false;
  int _currentIndex = 0;

  void _toggleTap() => setState(() => _isTap = !_isTap);
  void _onPageChanged(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final globalAsync = ref.watch(globalDataProvider);

    final global = globalAsync.value;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day selector always shows
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DayItem(
                  progressDays: global?.progressDays ?? {},
                  overDays: global?.overDays ?? {},
                  dailyCalories: global?.dailyCalories ?? {},
                  calorieGoal: global?.calorieGoal ?? 0,
                  selectedDateId: global?.activeDateId ?? '',
                  onDaySelected: (dateId) {
                    if (global != null) {
                      ref
                          .read(globalDataProvider.notifier)
                          .selectDay(dateId);
                    }
                  },
                ),
              ),

              // Carousel always visible
              CarouselView(
                isTap: _isTap,
                onTap: _toggleTap,
                currentIndex: _currentIndex,
                onPageChanged: _onPageChanged,
                onWaterChange: (_) {},
              ),

              const SizedBox(height: 30),

              // Recently logged section handles its own empty state
              RecentlyUploadedSection(
                dateId: global?.activeDateId ?? '',
              ),

              const SizedBox(height: 300),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// ------------------------------------------------------------
// LOG ITEM FACTORY
// ------------------------------------------------------------

Widget buildLogItem(Map<String, dynamic> data) {
  final source = data['source'] as String? ?? 'unknown';

  // 1. Check for Exercise
  if (source == 'exercise' || data.containsKey('caloriesBurned')) {
    return ExerciseLogCard(
      exercise: Exercise.fromJson(data),
    );
  }

  // 2. Check for Food
  if (source == 'food-database' || source == 'food-upload' || data.containsKey('calories')) {
    return FoodLogCard(
      food: FoodLog.fromJson(data),
    );
  }

  return const SizedBox.shrink();
}