import 'package:calai/pages/home/recently_logged/log_card.dart';
import 'package:calai/pages/home/recently_logged/recently_logged_section.dart';
import 'package:calai/providers/global_provider.dart';
import 'package:flutter/material.dart' hide CarouselView;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calai/api/exercise_api.dart';

import '../../models/exercise_model.dart';
import '../../models/food_model.dart';
import '../shell/widgets/widget_app_bar.dart';
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

    return CustomScrollView(
      key: const PageStorageKey('home_scroll'),
      slivers: [
        const WidgetTreeAppBar(),
        SliverToBoxAdapter(
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
                    dailyCalories: global?.dailyNutrition ?? [],
                    calorieGoal: global?.todayGoal.calories.toDouble() ?? 0,
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
                  date: (global?.activeDateId != null)
                      ? DateTime.parse(global!.activeDateId)
                      : DateTime.now(),
                  onWaterChange: (_) {},
                ),

                const SizedBox(height: 30),

                // Recently logged section handles its own empty state
                RecentlyUploadedSection(
                  dateId: global?.activeDateId ?? '',
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),]
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// ------------------------------------------------------------
// LOG ITEM FACTORY
// ------------------------------------------------------------

Widget buildLogItem(Map<String, dynamic> data, {VoidCallback? onDelete}) {  final source = data['source'] as String? ?? 'unknown';

  // 1. Check for Exercise
  if (source == 'exercise' || data.containsKey('caloriesBurned')) {
    return ExerciseLogCard(
      exercise: ExerciseLog.fromJson(data),
      onDelete: onDelete,
    );
  }

  // 2. Check for Food
  if (source == 'food-database' || source == 'food-upload' || data.containsKey('calories')) {
    return FoodLogCard(
      food: FoodLog.fromJson(data),
      onDelete: onDelete,
    );
  }

  return const SizedBox.shrink();
}