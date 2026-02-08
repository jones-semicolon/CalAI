import 'package:calai/pages/home/floating_grid/log_exercise/run_page.dart';
import 'package:calai/pages/home/floating_grid/log_exercise/weight_lifting_page.dart';
import 'package:calai/widgets/circle_back_button.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/header_widget.dart';
import 'describe_page.dart';

class LogExercisePage extends StatefulWidget {
  const LogExercisePage({super.key});

  @override
  State<LogExercisePage> createState() => _LogExercisePageState();
}

class _LogExercisePageState extends State<LogExercisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Remove MainAxisAlignment.center from here if you want the AppBar at the top
          children: [
            const CustomAppBar(title: Text("Exercise")),
            const SizedBox(height: 20),

            // ✅ Use Expanded or just a simple Column here
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // This replaces the Spacers
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log Exercise",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(), // Use fixed spacing instead of Spacer

                    // Exercise Cards
                    _buildExerciseCard(
                      icon: Icons.directions_run,
                      title: "Run",
                      subtitle: "Running, jogging, sprinting, etc.",
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RunExercisePage())),
                    ),
                    _buildExerciseCard(
                      icon: Icons.fitness_center,
                      title: "Weight Lifting",
                      subtitle: "Machines, free weights, etc.",
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeightLiftingPage())),
                    ),
                    _buildExerciseCard(
                      icon: Icons.edit,
                      title: "Describe",
                      subtitle: "Write your workout in text",
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DescribePage())),
                    ),
                    Spacer(flex: 2,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper widget to build the reusable card
  Widget _buildExerciseCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                // Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}