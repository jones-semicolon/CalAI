import 'package:calai/widgets/profile_widgets/unit_toggle.dart';
import 'package:calai/widgets/circle_back_button.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:calai/widgets/weight_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/user_provider.dart';

class WeightPickerView extends ConsumerStatefulWidget {
  const WeightPickerView({super.key});

  @override
  ConsumerState<WeightPickerView> createState() => _WeightPickerViewState();
}

class _WeightPickerViewState extends ConsumerState<WeightPickerView> {
  double? _selectedWeight;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final body = user.body;

    _selectedWeight ??= body.currentWeight;

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: const Text("Set Weight")),
          const Spacer(), // Centers the picker vertically
          WeightPicker(
            initialWeight: body.currentWeight,
            referenceWeight: body.currentWeight,
            unit: body.weightUnit,
            showReferenceLine: false,
            onWeightChanged: (newWeight) {
              setState(() {
                _selectedWeight = newWeight;
              });
            },
            labelBuilder: (curr, selected) => "Current Weight",
          ),
          const Spacer(flex: 2), // Keeps the picker from hugging the bottom button
          ConfirmationButtonWidget(
            onConfirm: () {
              if (_selectedWeight != null) {
                // 1. Update the weight in the provider/database
                // Make sure your notifier method is named correctly (setWeight or setCurrentWeight)
                ref.read(userProvider.notifier).setWeight(
                  _selectedWeight!,
                  body.weightUnit,
                );

                // 2. Go back to the previous screen
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