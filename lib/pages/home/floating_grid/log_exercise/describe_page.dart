import 'package:calai/widgets/circle_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/exercise_api.dart';
import '../../../../data/global_data.dart';
import '../../../../data/user_data.dart';

class DescribePage extends ConsumerStatefulWidget {
  const DescribePage({super.key});

  @override
  ConsumerState<DescribePage> createState() => _DescribePageState();
}

class _DescribePageState extends ConsumerState<DescribePage> {
  // 1. Initialize the Controller
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    // 2. Clean up the controller when the widget is disposed
    _descriptionController.dispose();
    super.dispose();
  }

  void _onAdd() async {
    final String description = _descriptionController.text.trim();

    // Optional: Basic validation to prevent empty API calls
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your exercise.')),
      );
      return;
    }

    final user = ref.read(userProvider);
    final double weightKg = user.weight > 0 ? user.weight : 70.0;

    try {
      // 4. API CALL
      final apiResponse = await ExerciseApi().getBurnedCalories(
        weightKg: weightKg,
        description: description, // TODO FIXED: Passed description from controller
      );

      debugPrint(apiResponse.toString());

      // 5. EXTRACT DATA
      final dynamic rawCalories = apiResponse['data']['calories_burned'];

      final double burnedCalories = (rawCalories is num) ? rawCalories.toDouble() : 0.0;

      // 6. FIREBASE LOG
      await ref.read(globalDataProvider.notifier).logExerciseEntry(
        burnedCalories: burnedCalories,
        weightKg: weightKg,
        exerciseType: apiResponse['data']['exercise'],
        intensity: apiResponse['data']['intensity'],
        durationMins: apiResponse['data']['duration_mins'],
      );

      // 7. Success & Close
      if (mounted) {
        Navigator.pop(context); // Close the current page
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Logged exercise: ${burnedCalories.toInt()} kcal!')),
        // );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: const Padding(
          padding: EdgeInsets.all(5),
          child: CircleBackButton(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Describe Exercise',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // --- INPUT ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black12)),
                  child: TextField(
                    controller: _descriptionController, // 3. Link the controller here
                    maxLines: null, // Allows text to wrap
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What did you do?',
                        contentPadding: EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
                const SizedBox(height: 10,),
                const Text('Example: Outdoor hiking for 5 hours, felt exhausted',
                    style: TextStyle(fontSize: 12, color: Colors.grey))
              ],
            ),

            // --- BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1C29),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Add',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}