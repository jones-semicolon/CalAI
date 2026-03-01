import 'package:flutter/material.dart';
import 'package:calai/l10n/l10n.dart';
import 'card_decorations.dart';

/// A card widget to display the user's current day streak.
///
/// dayStreak must be [Sun, Mon, Tue, Wed, Thu, Fri, Sat]
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

  int _calculateStreakFromToday(List<bool> streakWeek) {
    if (streakWeek.length != 7) return 0;

    final today = DateTime.now().weekday % 7;

    int streak = 0;
    for (int i = today; i >= 0; i--) {
      if (streakWeek[i] == true) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final streak = _calculateStreakFromToday(dayStreak);

    return Stack(
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
                ..color = const Color.fromARGB(255, 249, 149, 11),
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
    );
  }
}

/// Private widget for the "Day streak" title.
class _StreakTitle extends StatelessWidget {
  const _StreakTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.dayStreakTitle,
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
    final l10n = context.l10n;
    final days = [
      l10n.dayInitialSun,
      l10n.dayInitialMon,
      l10n.dayInitialTue,
      l10n.dayInitialWed,
      l10n.dayInitialThu,
      l10n.dayInitialFri,
      l10n.dayInitialSat,
    ];
    // ✅ Calculate today's index once (0 for Sunday, 6 for Saturday)
    final int todayIndex = DateTime.now().weekday % 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        return _DayIndicator(
          day: days[i],
          isDone: dayStreak[i],
          isToday: i == todayIndex, // ✅ New parameter
        );
      }),
    );
  }
}

/// Private widget for a single day's streak indicator.
class _DayIndicator extends StatelessWidget {
  final String day;
  final bool isDone;
  final bool isToday; // ✅ Added this

  const _DayIndicator({
    required this.day,
    required this.isDone,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color.fromARGB(255, 249, 149, 11);
    // You can choose any color for "Today" (e.g., Blue or a stronger shade of your primary)
    final todayColor = activeColor;
    final inactiveColor = Theme.of(context).colorScheme.onTertiary;

    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday
                ? todayColor // ✅ Highlight if today
                : (isDone ? activeColor : Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: 8,
          // We keep the circle logic based on progress (isDone)
          backgroundColor: isDone ? activeColor : inactiveColor,
          // But maybe add a border if it is today but not done?
          child: isDone
              ? const Icon(Icons.check, size: 12, color: Colors.white): null,
        ),
      ],
    );
  }
}
