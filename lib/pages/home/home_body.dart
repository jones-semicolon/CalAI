import 'package:calai/pages/home/recently_logged/log_card.dart';
import 'package:calai/pages/home/recently_logged/recently_logged_section.dart';
import 'package:calai/providers/global_provider.dart';
import 'package:flutter/material.dart' hide CarouselView;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/exercise_model.dart';
import '../../models/food_model.dart';
import '../shell/widgets/widget_app_bar.dart';
import 'calendar/day_item.dart';
import 'carousel/carousel_view.dart';

const double _maxContentWidth = 700;

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

    // ✅ OPTIMIZATION: Use .select to watch only specific properties.
    // This prevents the entire HomeBody from rebuilding when unrelated data changes.
    final activeDateId = ref.watch(globalDataProvider.select((async) => async.value?.activeDateId ?? ''));
    final calorieGoal = ref.watch(globalDataProvider.select((async) => async.value?.todayGoal.calories.toDouble() ?? 0.0));
    final progressDays = ref.watch(globalDataProvider.select((async) => async.value?.progressDays ?? {}));
    final dailyNutrition = ref.watch(globalDataProvider.select((async) => async.value?.dailyNutrition ?? []));

    return CustomScrollView(
      // ✅ Optimization: Using slivers properly reduces the layout passes
      slivers: [
        const WidgetTreeAppBar(),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DAY SELECTOR ---
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DayItem(
                      progressDays: progressDays,
                      dailyCalories: dailyNutrition,
                      calorieGoal: calorieGoal,
                      selectedDateId: activeDateId,
                      onDaySelected: (dateId) {
                        // ✅ Optimization: read(notifier) doesn't cause a rebuild
                        ref.read(globalDataProvider.notifier).selectDay(dateId);
                      },
                    ),
                  ),

                  // --- CAROUSEL VIEW ---
                  // ✅ Optimization: RepaintBoundary helps cache complex UI layers (shadows/gradients)
                  RepaintBoundary(
                    child: CarouselView(
                      key: ValueKey(activeDateId), // ✅ Keeps state tied to the date
                      isTap: _isTap,
                      onTap: _toggleTap,
                      currentIndex: _currentIndex,
                      onPageChanged: _onPageChanged,
                      date: activeDateId.isNotEmpty
                          ? DateTime.parse(activeDateId)
                          : DateTime.now(),
                      onWaterChange: (_) {},
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- RECENTLY LOGGED ---
                  // ✅ Optimization: RecentlyUploadedSection should use its own providers
                  // to keep this parent widget even lighter.
                  RecentlyUploadedSection(
                    dateId: activeDateId,
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ],
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