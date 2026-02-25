import 'package:calai/pages/home/floating_grid/food_database/food_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // ✅ Import this
import '../../../enums/food_enums.dart';
import '../../../models/exercise_model.dart';
import '../../../models/food_model.dart';
import 'logged_view/logged_exercise_view.dart';
import 'logged_view/logged_food_view.dart';

class FoodLogCard extends StatelessWidget {
  final FoodLog food;
  final VoidCallback? onDelete; // ✅ Added callback

  const FoodLogCard({super.key, required this.food, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return _BaseLogCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoggedFoodView(foodLog: food))),
      onDelete: onDelete,
      leading: food.imageUrl != null
          ? Image(image: NetworkImage(food.imageUrl!), fit: BoxFit.cover)
          : CircleAvatar(
        backgroundColor: Theme.of(context).cardColor,
        child: const Icon(Icons.restaurant),
      ),
      title: food.name,
      subtitle: DateFormat.jm().format(food.timestamp),
      calories: "${food.calories.round()} calories",
      bottom: Row(
        children: [
          _macro(NutritionType.protein, "${food.protein.round()}g"),
          const SizedBox(width: 10),
          _macro(NutritionType.carbs, "${food.carbs.round()}g"),
          const SizedBox(width: 10),
          _macro(NutritionType.fats, "${food.fats.round()}g"),
        ],
      ),
    );
  }
}

class ExerciseLogCard extends StatelessWidget {
  final ExerciseLog exercise;
  final VoidCallback? onDelete; // ✅ Added callback

  const ExerciseLogCard({super.key, required this.exercise, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final type = exercise.type;

    return _BaseLogCard(
      onDelete: onDelete,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditExercisePage(exercise: exercise))),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).cardColor,
        child: Icon(type.icon),
      ),
      title: type.label,
      subtitle: exercise.formattedTime,
      calories: "${exercise.caloriesBurned.round()} kcal",
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

class _BaseLogCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String calories;
  final Widget bottom;
  final VoidCallback? onDelete;
  final VoidCallback? onTap; // ✅ Added onTap

  const _BaseLogCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.bottom,
    this.onDelete,
    this.onTap, // ✅ Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    const double cardRadius = 24.0;
    final cardColor = Theme.of(context).appBarTheme.backgroundColor;
    final borderColor = Theme.of(context).splashColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: Slidable(
          key: ValueKey(title + subtitle),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.50,
            dismissible: DismissiblePane(
              onDismissed: () => onDelete?.call(),
            ),
            children: [
              SlidableAction(
                onPressed: (_) =>
                  onDelete?.call(),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                label: 'Delete',
                // ✅ 2. Keep this for internal rounding logic
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(cardRadius),
                  bottomRight: Radius.circular(cardRadius),
                ),
              ),
            ],
          ),
          child: InkWell( // ✅ Added InkWell for ripple effect
            onTap: onTap,
            borderRadius: BorderRadius.circular(cardRadius),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(cardRadius),
                border: Border.all(color: borderColor, width: 0.5),
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
                                    fontWeight: FontWeight.bold, fontSize: 16),
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
                        Text(calories,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        bottom,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ✅ 2. Wrap in Material & InkWell for the native ripple tap effect
    return Material(
      color: theme.appBarTheme.backgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FoodDatabasePage(), 
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            // We moved the background color up to the Material widget so the ripple shows
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.splashColor),
          ),
          child: const Text(
            "Tap + to add your first entry",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// HELPERS
// ------------------------------------------------------------

Widget _macro(NutritionType nutrition, String label) {
  return Row(
    children: [
      Icon(nutrition.icon, size: 12, color: nutrition.color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
    ],
  );
}
