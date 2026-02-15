import 'package:calai/widgets/profile_widgets/unit_toggle.dart';
import 'package:calai/widgets/circle_back_button.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/weight_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/user_provider.dart';
import '../../../widgets/header_widget.dart';

class GoalPickerView extends ConsumerStatefulWidget {
  const GoalPickerView({super.key});

  @override
  ConsumerState<GoalPickerView> createState() => _GoalPickerViewState();
}

class _GoalPickerViewState extends ConsumerState<GoalPickerView> {
  double? _selectedGoalWeight;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final body = user.body;
    final goal = user.goal;

    // Initialize with the existing target weight
    _selectedGoalWeight ??= goal.targets.weightGoal.toDouble();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          CustomAppBar(
            title: const Text("Edit Goal Picker")),
          const Spacer(),
          WeightPicker(
            // ✅ Start the picker at the current Target Weight
            initialWeight: goal.targets.weightGoal.toDouble(),
            // ✅ Use Current Weight as the static reference line
            referenceWeight: body.currentWeight,
            unit: body.weightUnit,
            showReferenceLine: true, // ✅ Show where they are now vs the goal
            onWeightChanged: (newWeight) {
              setState(() {
                _selectedGoalWeight = newWeight;
              });
            },
            // ✅ Dynamic label based on whether they are gaining or losing
            labelBuilder: (current, selected) {
              if (selected > current) return "Gain Weight";
              if (selected < current) return "Lose Weight";
              return "Maintain Weight";
            },
          ),
          const Spacer(flex: 2),
          ConfirmationButtonWidget(
            onConfirm: () {
              if (_selectedGoalWeight != null) {
                // ✅ Update the Target Weight instead of Current Weight
                ref.read(userProvider.notifier).setTargetWeight(_selectedGoalWeight!);

                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}