// ------------------------------------------------------------
// FOOD LOG CARD
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../api/exercise_api.dart';
import '../../../models/food.dart';

class FoodLogCard extends StatelessWidget {
  final FoodLog food;
  const FoodLogCard({super.key, required this.food});


  @override
  Widget build(BuildContext context) {
    // debugPrint("FoodLogCard: ${food.toJson()}");
    return _BaseLogCard(
      leading: food.imageUrl != null
          ? CircleAvatar(backgroundImage: NetworkImage(food.imageUrl!))
          : CircleAvatar(backgroundColor: Theme.of(context).cardColor, child: const Icon(Icons.restaurant)),
      title: food.name,
      subtitle: DateFormat.jm().format(food.timestamp),
      calories: "${food.calories} calories",
      bottom: Row(
        children: [
          _macro(Icons.egg_alt, "${food.protein}g", Colors.redAccent),
          const SizedBox(width: 10),
          _macro(Icons.rice_bowl, "${food.carbs}g", Colors.orangeAccent),
          const SizedBox(width: 10),
          _macro(Icons.fastfood_outlined, "${food.fats}g", Colors.blueAccent),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// EXERCISE LOG CARD
// ------------------------------------------------------------

class ExerciseLogCard extends StatelessWidget {
  final Exercise exercise;
  const ExerciseLogCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final type = ExerciseType.fromString(exercise.type);

    return _BaseLogCard(
      leading: CircleAvatar(backgroundColor: Theme.of(context).cardColor, child: Icon(type.icon)),
      title: type.label,
      subtitle: exercise.formattedTime,
      calories: "${exercise.caloriesBurned} kcal",
      bottom: Row(
        children: [
          Icon(Icons.bolt, size: 14, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Text(exercise.intensity.label),
          const SizedBox(width: 12),
          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Text("${exercise.durationMins}m"),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// BASE CARD + EMPTY STATE
// ------------------------------------------------------------

class _BaseLogCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String calories;
  final Widget bottom;

  const _BaseLogCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).splashColor, width: 0.5),
      ),
      child: Row(
        children: [
          SizedBox(width: 48, height: 48, child: leading),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  calories,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                bottom,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).splashColor),
      ),
      child: const Text(
        "Tap + to add your first entry",
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ------------------------------------------------------------
// HELPERS
// ------------------------------------------------------------

Widget _macro(IconData icon, String label, Color color) {
  return Row(
    children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
    ],
  );
}
