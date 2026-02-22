import 'package:calai/widgets/circle_back_button.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/exercise_api.dart';
import '../../../../enums/exercise_enums.dart';
import '../../../../providers/exercise_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../services/calai_firestore_service.dart';

class DescribePage extends ConsumerStatefulWidget {
  const DescribePage({super.key});

  @override
  ConsumerState<DescribePage> createState() => _DescribePageState();
}

class _DescribePageState extends ConsumerState<DescribePage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onLogEntry() async {
    final String description = _descriptionController.text.trim();
    if (description.isEmpty) return;

    // Use the provider logic for "Natural Language" logging
    // We pass duration 0 so the API knows to parse the description instead
    await ref.read(exerciseLogProvider.notifier).logExerciseDescription(
      description: description, // Pass the new description field
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Listen for state changes (Loading/Success/Error)
    ref.listen<ExerciseLogState>(exerciseLogProvider, (previous, next) {
      if (next.status == ExerciseLogStatus.loading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      } else if (next.status == ExerciseLogStatus.success) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading
        Navigator.pop(context); // Close DescribePage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise parsed and logged!')),
        );
        ref.read(exerciseLogProvider.notifier).reset();
      } else if (next.status == ExerciseLogStatus.error) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.errorMessage}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: SizedBox.shrink()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Describe Exercise',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What did you do?',
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Example: Outdoor hiking for 5 hours, felt exhausted',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // --- BUTTON ---
          ConfirmationButtonWidget(onConfirm: _onLogEntry)
        ],
      ),
    );
  }
}