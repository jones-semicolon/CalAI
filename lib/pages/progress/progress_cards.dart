import 'package:flutter/material.dart';

class WeightCard extends StatelessWidget {
  final double currentWeight;
  final double goalWeight;
  final double progressPercent;

  const WeightCard({
    super.key,
    required this.currentWeight,
    required this.goalWeight,
    required this.progressPercent,
  });

  String formatKg(double v) => '${v.toStringAsFixed(1)} kg';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap event, e.g., navigate to log weight page
      },
      child: Container(
        decoration: _decoration(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'My Weight',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatKg(currentWeight),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10),
                        value: (progressPercent / 100).clamp(0.0, 1.0),
                        backgroundColor: Colors.transparent,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Goal',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ' ${formatKg(goalWeight)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Log Weight',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 22,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreakCard extends StatelessWidget {
  final List<bool> dayStreak;

  const StreakCard({super.key, required this.dayStreak});

  @override
  Widget build(BuildContext context) {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final streak = dayStreak.reversed.takeWhile((e) => e).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoration(context),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.local_fire_department,
                size: 70,
                color: Color.fromARGB(255, 249, 149, 11),
              ),
              Positioned(
                top: 35,
                child: Text(
                  '$streak',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..color = Color.fromARGB(255, 249, 149, 11),
                  ),
                ),
              ),
              Positioned(
                top: 35,
                child: Text(
                  '$streak',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Day streak',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 249, 149, 11),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final done = dayStreak[i];
              return Column(
                children: [
                  Text(
                    days[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: done
                          ? Color.fromARGB(255, 249, 149, 11)
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: done
                        ? Color.fromARGB(255, 249, 149, 11)
                        : Theme.of(context).dialogTheme.backgroundColor,
                    child: done
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _decoration(BuildContext context) => BoxDecoration(
  color: Theme.of(context).scaffoldBackgroundColor,
  borderRadius: BorderRadius.circular(25),
  border: Border.all(color: Theme.of(context).dividerColor, width: 2),
);
