import 'package:calai/models/nutrition_model.dart';
import 'package:calai/pages/settings/screens/generate_goals_view.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:calai/l10n/l10n.dart';
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

class _EditGoalsViewState extends ConsumerState<EditGoalsView> {
  bool _showMicros = false;

  @override
  Widget build(BuildContext context) {
    // Watching the user provider for current targets
    final user = ref.watch(userProvider);
    final targets = user.goal.targets;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          CustomAppBar(title: SizedBox.shrink()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.adjustMacronutrients,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Primary Macro Cards
                  _GoalCard(
                    label: l10n.calorieGoalLabel,
                    value: targets.calories,
                    color: Colors.black,
                    icon: Icons.local_fire_department,
                    onTap: () => _showEdit(
                      context,
                      l10n.caloriesLabel,
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
                    label: l10n.proteinGoalLabel,
                    value: targets.protein,
                    color: NutritionType.protein.color,
                    icon: NutritionType.protein.icon,
                    onTap: () => _showEdit(
                      context,
                      l10n.proteinLabel,
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
                    label: l10n.carbGoalLabel,
                    value: targets.carbs,
                    color: NutritionType.carbs.color,
                    icon: NutritionType.carbs.icon,
                    onTap: () => _showEdit(
                      context,
                      l10n.carbsLabel,
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
                    label: l10n.fatGoalLabel,
                    value: targets.fats,
                    color: NutritionType.fats.color,
                    icon: NutritionType.fats.icon,
                    onTap: () => _showEdit(
                      context,
                      l10n.fatsLabel,
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
                      onPressed: () =>
                          setState(() => _showMicros = !_showMicros),
                      icon: Text(
                        _showMicros ? l10n.hideMicronutrientsLabel : l10n.viewMicronutrientsLabel,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      label: Icon(
                        _showMicros
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  // ✅ 3. Conditional Micronutrient Section
                  if (_showMicros) ...[
                    const SizedBox(height: 10),
                    _GoalCard(
                      label: l10n.sugarLimitLabel,
                      value: targets.sugar,
                      color: MicroNutritionType.sugar.color,
                      icon: MicroNutritionType.sugar.icon,
                      onTap: () => _showEdit(
                        context,
                        l10n.sugarLabel,
                        targets.sugar,
                        Colors.purple,
                            (v) {
                          ref
                              .read(userProvider.notifier)
                              .updateLocal(
                                (s) => s.copyWith(
                              goal: s.goal.copyWith(
                                targets: s.goal.targets.copyWith(sugar: v),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _GoalCard(
                      label: l10n.fiberGoalLabel,
                      value: targets.fiber,
                      color: MicroNutritionType.fiber.color,
                      icon: MicroNutritionType.fiber.icon,
                      onTap: () => _showEdit(
                        context,
                        l10n.fiberLabel,
                        targets.fiber,
                        Colors.green,
                            (v) {
                          ref
                              .read(userProvider.notifier)
                              .updateLocal(
                                (s) => s.copyWith(
                              goal: s.goal.copyWith(
                                targets: s.goal.targets.copyWith(fiber: v),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _GoalCard(
                      label: l10n.sodiumLimitLabel,
                      value: targets.sodium,
                      color: MicroNutritionType.sodium.color,
                      icon: MicroNutritionType.sodium.icon,
                      onTap: () => _showEdit(
                        context,
                        l10n.sodiumLabel,
                        targets.sodium,
                        Colors.blueGrey,
                            (v) {
                          ref
                              .read(userProvider.notifier)
                              .updateLocal(
                                (s) => s.copyWith(
                              goal: s.goal.copyWith(
                                targets: s.goal.targets.copyWith(sodium: v),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action Button
          ConfirmationButtonWidget(
            onConfirm: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GenerateGoalsView()),
            ),
            text: l10n.autoGenerateGoalsLabel,
          ),
        ],
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    color: color,
                    backgroundColor: Theme.of(context).splashColor,
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
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12),
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
