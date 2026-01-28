import 'package:calai/pages/home/floating_grid/log_exercise/run_page.dart';
import 'package:calai/pages/home/floating_grid/log_exercise/weight_lifting_page.dart';
import 'package:calai/widgets/circle_back_button.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: CircleBackButton(onTap: () => Navigator.pop(context)),
        ),
        title: const Text(
          "Exercise",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Header
              SizedBox(height: 20,),
              const Text(
                "Log Exercise",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Column(
                children: [
                  // Option 1: Run
                  _buildExerciseCard(
                    icon: Icons.directions_run,
                    title: "Run",
                    subtitle: "Running, jogging, sprinting, etc.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RunExercisePage(),
                        ),
                      );
                    },
                  ),

                  // Option 2: Weight Lifting
                  _buildExerciseCard(
                    icon: Icons.fitness_center,
                    title: "Weight Lifting",
                    subtitle: "Machines, free weights, etc.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WeightLiftingPage(),
                        ),
                      );
                    },
                  ),

                  // Option 3: Describe
                  _buildExerciseCard(
                    icon: Icons.edit,
                    title: "Describe",
                    subtitle: "Write your workout in text",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DescribePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Spacer()
            ],
          ),
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
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
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