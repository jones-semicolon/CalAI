import 'package:flutter/material.dart';

class CalorieCard extends StatelessWidget {
  final String title;
  final int nutrients;
  final int progress;
  final Color color;
  final IconData icon;
  final bool isEaten; // new prop

  const CalorieCard({
    super.key,
    required this.title,
    required this.nutrients,
    required this.progress,
    required this.color,
    required this.icon,
    this.isEaten = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // First item: Calorie + title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEaten ? "$progress / $nutrients" : nutrients.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("$title ${isEaten ? 'eaten' : 'left'}"),
            ],
          ),

          const SizedBox(height: 20), // gap
          // Second item: circular progress indicator
          Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      value: (progress / nutrients).clamp(0.0, 1.0),
                      strokeWidth: 6,
                      backgroundColor: Colors.grey.shade300,
                      color: color,
                    ),
                  ),
                  // Icon with grey circular background
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, // grey bg
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
