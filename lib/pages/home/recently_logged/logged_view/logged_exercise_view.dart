import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../enums/exercise_enums.dart';
import '../../../../models/exercise_model.dart';
import '../../../../providers/user_provider.dart';
import '../../../../widgets/header_widget.dart';

class EditExercisePage extends ConsumerStatefulWidget { // ✅ Change to ConsumerStatefulWidget
  final ExerciseLog exercise;

  const EditExercisePage({super.key, required this.exercise});

  @override
  ConsumerState<EditExercisePage> createState() => _EditExercisePageState();
}

class _EditExercisePageState extends ConsumerState<EditExercisePage> { // ✅ Change to ConsumerState
  late TextEditingController _calController;
  late TextEditingController _minController;
  late String _selectedIntensity;
  late final _exerciseData = widget.exercise;

  @override
  void initState() {
    super.initState();
    _calController = TextEditingController(text: _exerciseData.caloriesBurned.toString());
    _minController = TextEditingController(text: _exerciseData.durationMins.toString());
    _selectedIntensity = _exerciseData.intensity.label;
  }

  Future<void> _handleSave() async {
    // 1. Prepare the updated object
    final updatedExercise = widget.exercise.copyWith(
      caloriesBurned: double.tryParse(_calController.text) ?? widget.exercise.caloriesBurned,
      durationMins: int.tryParse(_minController.text) ?? widget.exercise.durationMins,
      intensity: Intensity.fromString(_selectedIntensity),
      timestamp: DateTime.now(),
    );

    try {
      // 2. Trigger the update directly via the notifier
      // We use 'read' here because we are inside a callback
      await ref.read(userProvider.notifier).updateExercise(widget.exercise, updatedExercise);

      // 3. Navigate back only after successful save
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Handle potential Firestore errors (e.g. offline)
      debugPrint("Update failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          CustomAppBar(title: Text(_exerciseData.type.label)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Stats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Side-by-side Inputs
                  Row(
                    children: [
                      Expanded(child: _buildInput("Calories", _calController, "kcal")),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInput("Duration", _minController, "mins")),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Text("Intensity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Custom Intensity Selector
                  _IntensityPicker(
                    selected: _selectedIntensity,
                    onSelect: (val) => setState(() => _selectedIntensity = val),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Button at the bottom
          ConfirmationButtonWidget(
            onConfirm: _handleSave,
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, String suffix) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        filled: true,
        fillColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          // borderSide: BorderSide.none,
        ),
        suffixIconColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _IntensityPicker extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const _IntensityPicker({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final levels = ['Low', 'Moderate', 'High'];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: levels.map((level) {
          final isSelected = selected == level;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(level),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  level,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}