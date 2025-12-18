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
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox( 
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      isEaten ? progress.toString() : "${nutrients}g",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    if (isEaten)
                      Baseline(
                        baseline: 10,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          " /${progress}g",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    isEaten ? " eaten" : " left",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              )
            ],
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 55,
                      width: 55,
                      child: CircularProgressIndicator(
                        value: (progress / nutrients).clamp(0.0, 1.0),
                        strokeWidth: 5,
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