import 'package:calai/onboarding/onboarding_widgets/header.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/weight_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/weight_picker/weight_selection_view.dart';

class WeightPickerPage extends ConsumerWidget {
  final VoidCallback nextPage;

  const WeightPickerPage({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          const Header(title: 'What is your desired weight?'),

          const Spacer(),

          // const WeightSelectionView(),
          WeightPicker(
            initialWeight: user.goal.type == Goal.loseWeight ? user.body.currentWeight - 5 : user.body.currentWeight + 5,
            referenceWeight: user.body.currentWeight,
            unit: user.body.weightUnit,
            labelBuilder: (current, selected) {
              if (selected > current) return "Gain Weight";
              if (selected < current) return "Lose Weight";
              return "Maintain Weight";
            },
            onWeightChanged: (kg) {
              userNotifier.updateLocal((s) => s.copyWith(goal: s.goal.copyWith(targets: s.goal.targets.copyWith(targetWeight: kg))));
            }
          ),

          const Spacer(),
          
          ConfirmationButtonWidget(onConfirm: () => nextPage())
        ],
      ),
    );
  }
}
