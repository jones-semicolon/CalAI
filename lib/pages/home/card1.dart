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

  bool get overEat {
    return progress > nutrients;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    Widget valueText(String text, {double fontSize = 16, Color? color}) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: textStyle.copyWith(
            fontSize: fontSize,
            color: color ?? textStyle.color,
          ),
        ),
      );
    }

    return Container(
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
              !isEaten
                  ? overEat
                        ? valueText("${progress - nutrients}g")
                        : valueText("${nutrients}g")
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        valueText(progress.toString()),
                        const SizedBox(width: 5),
                        valueText(
                          '/${nutrients}g',
                          fontSize: 11,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ],
                    ),
              Text(
                "$title ${isEaten ? 'eaten' : (overEat ? 'over' : 'left')}",
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
