import 'package:calai/models/nutrition_model.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/widgets/edit_value_view.dart'; // Using your EditModal
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/providers/user_provider.dart';

import '../../../enums/food_enums.dart';

class EditGoalsView extends ConsumerStatefulWidget {
  const EditGoalsView({super.key});

  @override
  ConsumerState<EditGoalsView> createState() => _EditGoalsViewState();
}

// TODO: Needs an optimization
class _EditGoalsViewState extends ConsumerState<EditGoalsView> {
  bool _showMicros = false;

  @override
  Widget build(BuildContext context) {
    // Watching the user provider for current targets
    final user = ref.watch(userProvider);
    final targets = user.goal.targets;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // TODO :: onBackTap will trigger to save the data globally then pop the view
          CustomAppBar(title: SizedBox.shrink()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit nutrition goals",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Primary Macro Cards
                  _GoalCard(
                    label: "Calorie goal",
                    value: targets.calories,
                    color: Colors.black,
                    icon: Icons.local_fire_department,
                    // TODO this should only update the UI but not the provider
                    onTap: () => _showEdit(
                      context,
                      "Calories",
                      targets.calories,
                      Colors.black,
                      (v) {
                        ref
                            .read(userProvider.notifier)
                            .updateLocal(
                              (s) => s.copyWith(
                                goal: s.goal.copyWith(
                                  targets: s.goal.targets.copyWith(calories: v),
                                ),
                              ),
                            );
                      },
                    ),
                  ),
                  _GoalCard(
                    label: "Protein goal",
                    value: targets.protein,
                    color: NutritionType.protein.color,
                    icon: NutritionType.protein.icon,
                    onTap: () => _showEdit(
                      context,
                      "Protein",
                      targets.protein,
                      Theme.of(context).colorScheme.primary,
                      (v) {
                        ref
                            .read(userProvider.notifier)
                            .updateLocal(
                              (s) => s.copyWith(
                                goal: s.goal.copyWith(
                                  targets: s.goal.targets.copyWith(protein: v),
                                ),
                              ),
                            );
                      },
                    ),
                  ),
                  _GoalCard(
                    label: "Carb goal",
                    value: targets.carbs,
                    color: NutritionType.carbs.color,
                    icon: NutritionType.carbs.icon,
                    onTap: () => _showEdit(
                      context,
                      "Carbs",
                      targets.carbs,
                      Theme.of(context).colorScheme.primary,
                      (v) {
                        ref
                            .read(userProvider.notifier)
                            .updateLocal(
                              (s) => s.copyWith(
                                goal: s.goal.copyWith(
                                  targets: s.goal.targets.copyWith(carbs: v),
                                ),
                              ),
                            );
                      },
                    ),
                  ),
                  _GoalCard(
                    label: "Fat goal",
                    value: targets.fats,
                    color: NutritionType.fats.color,
                    icon: NutritionType.fats.icon,
                    onTap: () => _showEdit(
                      context,
                      "Fats",
                      targets.fats,
                      Colors.black,
                      (v) {
                        ref
                            .read(userProvider.notifier)
                            .updateLocal(
                              (s) => s.copyWith(
                                goal: s.goal.copyWith(
                                  targets: s.goal.targets.copyWith(fats: v),
                                ),
                              ),
                            );
                      },
                    ),
                  ),

                  // Expandable Section
                  Center(
                    child: TextButton.icon(
                      onPressed: () => setState(() => _showMicros = !_showMicros),
                      icon: Text(
                        _showMicros ? "Hide micronutrients" : "View micronutrients",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      label: Icon(
                        _showMicros ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  // ✅ 3. Conditional Micronutrient Section
                  if (_showMicros) ...[
                    const SizedBox(height: 10),
                    _GoalCard(
                      label: "Sugar limit",
                      value: targets.sugar,
                      color: MicroNutritionType.sugar.color,
                      icon: MicroNutritionType.sugar.icon,
                      onTap: () => _showEdit(context, "Sugar", targets.sugar, Colors.purple, (v) {
                        _updateTarget((t) => t.copyWith(sugar: v));
                      }),
                    ),
                    _GoalCard(
                      label: "Fiber goal",
                      value: targets.fiber,
                      color: MicroNutritionType.fiber.color,
                      icon: MicroNutritionType.fiber.icon,
                      onTap: () => _showEdit(context, "Fiber", targets.fiber, Colors.green, (v) {
                        _updateTarget((t) => t.copyWith(fiber: v));
                      }),
                    ),
                    _GoalCard(
                      label: "Sodium limit",
                      value: targets.sodium,
                      color: MicroNutritionType.sodium.color,
                      icon: MicroNutritionType.sodium.icon,
                      onTap: () => _showEdit(context, "Sodium", targets.sodium, Colors.blueGrey, (v) {
                        _updateTarget((t) => t.copyWith(sodium: v));
                      }),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action Button
          ConfirmationButtonWidget(
            onConfirm: () {
              // TODO :: This will show the parts of onboarding to Generate Goals
              // Logic to re-calculate based on user profile
            },
            text: "Auto Generate Goals",
          ),
        ],
      ),
    );
  }

  void _updateTarget(NutritionGoals Function(NutritionGoals) updateFn) {
    ref.read(userProvider.notifier).updateLocal(
          (s) => s.copyWith(
        goal: s.goal.copyWith(
          targets: updateFn(s.goal.targets),
        ),
      ),
    );
  }

  void _showEdit(
    BuildContext context,
    String title,
    double val,
    Color color,
    Function(double) onSaved,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => EditModal(
        initialValue: val,
        title: title,
        label: title,
        color: color,
        onDone: (newVal) {
          onSaved(newVal);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _GoalCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Circular Indicator Icon
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: 0.5, // Decorative progress
                    strokeWidth: 4,
                    color: color.withOpacity(0.5),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                Icon(icon, color: color, size: 16),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
