import 'package:calai/api/exercise_api.dart';
import 'package:calai/api/food_api.dart';
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
      // ✅ skipLoadingOnRefresh: true prevents the whole screen from turning into
      // a loading spinner when data updates in the background.
      skipLoadingOnRefresh: true,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
      data: (global) {
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

                  // Carousel UI logic isolated to HomeBody's setState
                  _CarouselView(
                    isTap: _isTap,
                    onTap: () => setState(() => _isTap = !_isTap),
                    health: health,
                    onWaterChange: (amount) {
                      // Call your notifier if you have water update logic
                    },
                    currentIndex: _currentIndex,
                    onPageChanged: (index, _) =>
                        setState(() => _currentIndex = index),
                  ),

                  const SizedBox(height: 30),

                  // ✅ Pass the active date to the section
                  _RecentlyUploadedSection(dateId: global.activeDateId),

                  const SizedBox(height: 300),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- LOG CARD WIDGETS ---

class _FoodLogCard extends StatelessWidget {
  final Food food;
  const _FoodLogCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: food.imageUrl != null
                  ? DecorationImage(image: NetworkImage(food.imageUrl!), fit: BoxFit.cover)
                  : null,
            ),
            child: food.imageUrl == null
                ? const Icon(Icons.restaurant, color: Colors.black, size: 24)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis)),
                    Text(food.formattedTime, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Text("${food.calories} kcal", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _macro(Icons.egg_alt, "${food.protein}g", Colors.redAccent),
                    const SizedBox(width: 10),
                    _macro(Icons.rice_bowl, "${food.carbs}g", Colors.orangeAccent),
                    const SizedBox(width: 10),
                    _macro(Icons.fastfood_outlined, "${food.fats}g", Colors.blueAccent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macro(IconData icon, String label, Color color) => Row(children: [
    Icon(icon, size: 12, color: color),
    const SizedBox(width: 4),
    Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
  ]);
}

class _ExerciseLogCard extends StatelessWidget {
  final Exercise exercise;
  const _ExerciseLogCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final type = ExerciseType.fromString(exercise.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(type.icon, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(type.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(exercise.formattedTime, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.local_fire_department, size: 16, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text("${exercise.caloriesBurned} kcal", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  Icon(Icons.bolt, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(exercise.intensity.label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text("${exercise.durationMins}m", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- RECENTLY LOGGED SECTION ---

class _RecentlyUploadedSection extends ConsumerWidget {
  final String dateId;
  const _RecentlyUploadedSection({required this.dateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Use ref.watch on our StreamProvider. This keeps the data
    // cached even if HomeBody rebuilds.
    final entriesAsync = ref.watch(dailyEntriesProvider(dateId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recently logged", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          entriesAsync.when(
            // skipLoadingOnReload ensures we don't show a spinner every time a small change happens
            skipLoadingOnReload: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Error loading logs: $e"),
            data: (entries) {
              if (entries.isEmpty) {
                return _EmptyState();
              }
              return Column(
                children: entries.map((data) => _buildItem(data)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> data) {
    final source = data['source'] ?? 'unknown';

    if (source == 'exercise' || data.containsKey('caloriesBurned')) {
      return _ExerciseLogCard(exercise: Exercise(
        id: data['id']?.toString() ?? '',
        type: data['exerciseType'] ?? 'Exercise',
        intensity: Intensity.fromString(data['intensity'] ?? 'Low'),
        durationMins: (data['durationMins'] ?? 0) as int,
        caloriesBurned: (data['caloriesBurned'] ?? 0).toInt(),
        timestamp: data['timestamp'] != null ? (data['timestamp'] as dynamic).toDate() : DateTime.now(),
      ));
    }

    if (source == 'food-database' || source == 'food-upload') {
      final macros = data['macros'] ?? {};
      return _FoodLogCard(food: Food(
        id: data['id'].toString(),
        name: data['name'] ?? 'Food',
        calories: (data['calories'] ?? 0).toInt(),
        protein: (macros['p'] ?? 0).toInt(),
        carbs: (macros['c'] ?? 0).toInt(),
        fats: (macros['f'] ?? 0).toInt(),
        timestamp: data['timestamp'] != null ? (data['timestamp'] as dynamic).toDate() : DateTime.now(),
      ));
    }
    return const SizedBox.shrink();
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).splashColor, width: 1),
      ),
      child: const Text("Tap + to add your first entry", textAlign: TextAlign.center),
    );
  }
}

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
        health: health,
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