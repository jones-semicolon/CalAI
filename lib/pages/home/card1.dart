// card1.dart
import 'package:flutter/material.dart';

class CalorieCard extends StatelessWidget {
  final String title;
  final int nutrients;
  final int progress;
  final Color color;
  final IconData icon;
  final bool isEaten; 

  const CalorieCard({
    super.key,
    required this.title,
    required this.nutrients,
    required this.progress,
    required this.color,
    required this.icon,
    this.isEaten = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // **FIX:** Explicitly defining height ensures the Spacer works correctly 
      // when inside an Expanded widget, preventing vertical collapse (the "disappearing card" issue).
      height: 150, 
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 1. Text Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox( 
                fit: BoxFit.scaleDown,
                child: Text(
                  isEaten ? "$progress /${nutrients}g" : "${nutrients}g",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              Text(
                "$title ${isEaten ? 'eaten' : 'left'}",
                style: TextStyle(
                  fontSize: 12, 
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),

          // 2. Spacer pushes content down
          const Spacer(), 

          // 3. Circular progress indicator
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        value: (progress / nutrients).clamp(0.0, 1.0),
                        strokeWidth: 4,
                        backgroundColor: Theme.of(context).cardColor,
                        color: color,
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 15, color: color),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}