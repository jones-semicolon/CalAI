import 'package:flutter/material.dart';
import 'card_decorations.dart';

/// A card widget to display the user's current day streak.
///
/// It shows a prominent fire icon with the streak number and a weekly
/// view of completed days.
class StreakCard extends StatelessWidget {
  final List<bool> dayStreak;

  const StreakCard({super.key, required this.dayStreak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: progressCardDecoration(context),
      child: Column(
        children: [
          _StreakIcon(dayStreak: dayStreak),
          const SizedBox(height: 10),
          const _StreakTitle(),
          const SizedBox(height: 15),
          _WeeklyStreakView(dayStreak: dayStreak),
        ],
      ),
    );
  }
}

/// Private widget for the main fire icon and streak number.
class _StreakIcon extends StatelessWidget {
  final List<bool> dayStreak;

  const _StreakIcon({required this.dayStreak});

  @override
  Widget build(BuildContext context) {
    final streak = dayStreak.reversed.takeWhile((e) => e).length;

    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(
          Icons.local_fire_department,
          size: 70,
          color: Color.fromARGB(255, 249, 149, 11),
        ),
        // This creates the outlined text effect.
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
                ..color = const Color.fromARGB(255, 249, 149, 11),
            ),
          ),
        ),
        // This is the solid text on top of the outline.
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
    );
  }
}

/// Private widget for the "Day streak" title.
class _StreakTitle extends StatelessWidget {
  const _StreakTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Day streak',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 249, 149, 11),
      ),
    );
  }
}

/// Private widget for the row of weekly streak indicators.
class _WeeklyStreakView extends StatelessWidget {
  final List<bool> dayStreak;

  const _WeeklyStreakView({required this.dayStreak});

  @override
  Widget build(BuildContext context) {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        return _DayIndicator(
          day: days[i],
          isDone: dayStreak[i],
        );
      }),
    );
  }
}

/// Private widget for a single day's streak indicator.
class _DayIndicator extends StatelessWidget {
  final String day;
  final bool isDone;

  const _DayIndicator({required this.day, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color.fromARGB(255, 249, 149, 11);
    final inactiveColor = Theme.of(context).colorScheme.onTertiary;

    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 11,
            color: isDone ? activeColor : Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: 8,
          backgroundColor: isDone ? activeColor : inactiveColor,
          child: isDone
              ? const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                )
              : null,
        ),
      ],
    );
  }
}
