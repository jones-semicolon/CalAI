import 'package:calai/enums/food_enums.dart';
import 'package:calai/models/nutrition_model.dart';
import 'package:calai/providers/global_provider.dart';
import 'package:calai/providers/user_provider.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthScoreView extends ConsumerStatefulWidget {
  final double score;
  const HealthScoreView({super.key, required this.score});

  @override
  ConsumerState<HealthScoreView> createState() => _HealthScoreViewState();
}

class _HealthScoreViewState extends ConsumerState<HealthScoreView> {
  @override
  Widget build(BuildContext context) {
    // 1. Watch real-time data
    final globalAsync = ref.watch(globalDataProvider);
    final user = ref.watch(userProvider);
    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: SizedBox.shrink()),
              Expanded(
                child: globalAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text("Error loading data")),
                  data: (global) {
                    // --- DATA PREPARATION ---
                    final progress = global.todayProgress;
                    final calorieGoal = global.calorieGoal;

                    // Targets from User Profile (Ratios)
                    final targets = user.goal.targets;

                    // Calculate Gram Targets based on Calorie Goal
                    // Protein/Carbs = 4 kcal/g, Fat = 9 kcal/g
                    final double proteinGoal = (calorieGoal * (targets.protein / 100)) / 4;
                    final double carbsGoal = (calorieGoal * (targets.carbs / 100)) / 4;
                    final double fatsGoal = (calorieGoal * (targets.fats / 100)) / 9;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          const SizedBox(width: double.infinity, child: Text("Daily Breakdown", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),

                          // --- MACROS CARD ---
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: _cardDecoration(context),
                              child: Column(
                                spacing: 15, // Increased spacing for cleaner look
                                children: [
                                  // Calories Row
                                  Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Calories", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                                  Text(
                                                      "${progress.calories} / ${calorieGoal.round()} kcal",
                                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
                                                  )
                                                ]
                                            )
                                        ),
                                        _ProgressIndicator(
                                          progress: progress.calories.toDouble(),
                                          target: calorieGoal.toDouble(),
                                          color: theme.colorScheme.primary,
                                          child: const Icon(Icons.local_fire_department),
                                        )
                                      ]
                                  ),

                                  // Macro Rows
                                  _MacroRow(
                                      nutrition: NutritionType.protein,
                                      current: progress.protein,
                                      target: proteinGoal,
                                  ),
                                  _MacroRow(
                                      nutrition: NutritionType.carbs,
                                      current: progress.carbs,
                                      target: carbsGoal,
                                  ),
                                  _MacroRow(
                                      nutrition: NutritionType.fats,
                                      current: progress.fats,
                                      target: fatsGoal,
                                  ),

                                  const SizedBox(height: 5),
                                  ConfirmationButtonWidget(
                                    onConfirm: (){
                                      // TODO: Navigate to Edit Goals Page
                                    },
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: theme.colorScheme.secondary, width: 1.5),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    backgroundColor: theme.colorScheme.surface,
                                    color: theme.colorScheme.primary,
                                    text: "Edit Daily Goals",
                                  )
                                ],
                              )
                          ),

                          // --- WATER CARD ---
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: _cardDecoration(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Water", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text(
                                            "${progress.water} / ${user.goal.targets.water} fl oz",
                                            style: TextStyle(color: Colors.grey[600])
                                        )
                                      ]
                                  ),
                                  _ProgressIndicator(
                                      progress: progress.water.toDouble(),
                                      target: user.goal.targets.water.toDouble(),
                                      color: Colors.lightBlue,
                                      child: const Icon(Icons.water_drop_outlined, color: Colors.lightBlue)
                                  )
                                ],
                              )
                          ),

                          // --- HEALTH SCRORE CARD ---
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: _cardDecoration(context),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Health Score", style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary)),
                                            Text(
                                              getHealthStatus(widget.score),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        _ProgressIndicator(progress: widget.score, target: 10, color: Colors.red, child: Text("${widget.score.toInt()}/10"))
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    Column(
                                        spacing: 15,
                                        children: [
                                          _MicroRow(
                                              label: MicroNutritionType.fiber.label,
                                              val: progress.fiber,
                                              max: 30, // Standard recommendation
                                              icon: MicroNutritionType.fiber.icon
                                          ),
                                          _MicroRow(
                                              label: MicroNutritionType.sugar.label,
                                              val: progress.sugar,
                                              max: 50, // Standard limit
                                              icon: MicroNutritionType.sugar.icon
                                          ),
                                          _MicroRow(
                                              label: MicroNutritionType.sodium.label,
                                              val: progress.sodium,
                                              max: 2300, // Standard limit
                                              icon: MicroNutritionType.sodium.icon
                                          ),
                                        ]
                                    )
                                  ]
                              )
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).appBarTheme.backgroundColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

// --- Helper Components ---

class _MacroRow extends StatelessWidget {
  final NutritionType nutrition;
  final num current;
  final num target;

  const _MacroRow({
    required this.nutrition, required this.current, required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        spacing: 10,
        children: [
          Icon(nutrition.icon, size: 20, color: nutrition.color),
          Expanded(child: Text(nutrition.label, style: TextStyle(color: Colors.grey[700]),)),
          // e.g. "45 / 150g"
          Text(
              "${current.toInt()} / ${target.toInt()} grams",
              style: TextStyle(color: current > target ? Colors.red : Colors.grey[700])
          )
        ]
    );
  }
}

class _MicroRow extends StatelessWidget {
  final String label;
  final num val;
  final num max;
  final IconData icon;

  const _MicroRow({
    required this.label, required this.val, required this.max, required this.icon
  });

  @override
  Widget build(BuildContext context) {
    final isOverLimit = val > max;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        Row(
          children: [
            Text("${val.toInt()}", style: TextStyle(fontWeight: FontWeight.bold, color: isOverLimit ? Colors.red : null)),
            const SizedBox(width: 10),
            // Tiny status indicator
            Icon(
                isOverLimit ? Icons.circle : Icons.check_circle,
                size: 14,
                color: isOverLimit ? Colors.red : Colors.green
            )
          ],
        )
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;
  final double target;
  final Color color;
  final Widget child;

  const _ProgressIndicator({
    required this.progress,
    required this.target,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = target > 0
        ? (progress / target).clamp(0.0, 1.0)
        : 0.0;

    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: progressValue),
              builder: (context, value, _) => CircularProgressIndicator(
                value: value,
                strokeWidth: 5,
                strokeCap: StrokeCap.round,
                backgroundColor: Theme.of(context).splashColor,
                color: color,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

String getHealthStatus(double score) {
  if (score == 0) return "Not evaluated";
  if (score <= 3) return "Critically low";
  if (score <= 5) return "Needs improvement"; // ✅ Matches your current 4/10
  if (score <= 7) return "Fair progress";
  if (score <= 9) return "Good health";
  return "Excellent health";
}