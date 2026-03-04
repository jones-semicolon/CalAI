import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/widgets/header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/exercise_provider.dart';
import '../../../../l10n/l10n.dart';

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

    await ref.read(exerciseLogProvider.notifier).logExerciseDescription(
      description: description, 
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    ref.listen<ExerciseLogState>(exerciseLogProvider, (previous, next) {
      if (next.status == ExerciseLogStatus.loading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CupertinoActivityIndicator(radius: 15)),
        );
      } else if (next.status == ExerciseLogStatus.success) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exerciseParsedAndLogged)),
        );
        ref.read(exerciseLogProvider.notifier).reset();
      } else if (next.status == ExerciseLogStatus.error) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.genericErrorMessage(next.errorMessage ?? ''))),
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
                  Text(
                    l10n.describeExerciseTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        hintText: l10n.whatDidYouDoHint,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.describeExerciseExample,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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