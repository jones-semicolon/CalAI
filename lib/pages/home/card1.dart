import 'package:flutter/material.dart';
import '../../widgets/animated_number.dart';

class CalorieCard extends StatelessWidget {
  final String title;
  final int nutrients;
  final int progress;
  final Color color;
  final IconData icon;
  final bool isTap;
  final String unit;

  const CalorieCard({
    super.key,
    required this.title,
    required this.nutrients,
    required this.progress,
    required this.color,
    required this.icon,
    required this.unit,
    this.isTap = false,
  });

  @override
  Widget build(BuildContext context) {
    final int valueInt = isTap ? progress : (nutrients - progress);
    final String eaten = isTap ? "eaten" : "left";

    final valueStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Theme.of(context).colorScheme.primary,
      letterSpacing: 0
    );

    return Container(
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Theme.of(context).splashColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.start,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedSlideNumber(
                        value: valueInt.toString().split("").first,
                        style: valueStyle,
                        reverse: isTap,
                      ),
                      Text(
                        isTap
                            ? valueInt.toString().substring(1)
                            : "${valueInt.toString().substring(1)}$unit",
                        style: valueStyle,
                      ),
                    ],
                  ),
                  Baseline(
                    baseline: 18,
                    baselineType: TextBaseline.alphabetic,
                    child: AnimatedSlideNumber(
                      value: isTap ? " /$nutrients$unit" : "",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      reverse: isTap,
                      inAnim: false,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text: isTap ? " eaten" : " left",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 20,
          ),

          Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: (progress / nutrients).clamp(0.0, 1.0),
                      ),
                      builder: (context, value, _) => CircularProgressIndicator(
                        value: value,
                        strokeWidth: 5,
                        backgroundColor: Theme.of(context).splashColor,
                        color: color,
                      ),
                    ),
                  ),
                  Container(
                    height: 27,
                    width: 27,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 15, color: color),
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
