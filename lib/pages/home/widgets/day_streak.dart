import 'package:calai/pages/shell/widgets/streak_indicator_button.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import 'package:calai/l10n/l10n.dart';

class DayStreakDialog extends StatelessWidget {
  final List<bool> dayStreak;

  const DayStreakDialog({
    super.key,
    required this.dayStreak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // 1. Logic to count consecutive days ending today
    int calculateStreakFromToday(List<bool> streakWeek) {
      if (streakWeek.length != 7) return 0;

      // Calculate today's index (0=Sun, 6=Sat) based on your list structure
      final int todayIndex = DateTime.now().weekday % 7;

      int streak = 0;
      // Iterate backwards from today to check continuity
      for (int i = todayIndex; i >= 0; i--) {
        if (streakWeek[i] == true) {
          streak++;
        } else {
          // Break the count if we find a missed day
          break;
        }
      }
      return streak;
    }

    // ✅ 2. actually CALL the function to get the number
    final int streakCount = calculateStreakFromToday(dayStreak);

    // ✅ Determine State
    final bool isStreakActive = streakCount > 0;

    // ✅ Dynamic Colors & Text
    final Color stateColor = isStreakActive
        ? const Color.fromARGB(255, 249, 149, 11) // Orange
        : theme.disabledColor; // Grey

    final String title = isStreakActive
        ? context.l10n.dayStreakWithCount(streakCount)
        : context.l10n.streakLostTitle;

    final String subtitle = isStreakActive
        ? context.l10n.streakActiveSubtitle
        : context.l10n.streakLostSubtitle;

    return Center(
      child: Material(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: SizedBox(
          width: size.width * 0.9,
          height: size.height * 0.6,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 120,
                            color: stateColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: isStreakActive ? theme.colorScheme.primary : theme.disabledColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _WeeklyStreakView(dayStreak: dayStreak),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: StreakIndicatorButton(isDisabled: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    final int todayIndex = DateTime.now().weekday % 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        return _DayIndicator(
          day: days[i],
          isDone: dayStreak[i],
          isToday: i == todayIndex,
        );
      }),
    );
  }
}

class _DayIndicator extends StatelessWidget {
  final String day;
  final bool isDone;
  final bool isToday;

  const _DayIndicator({required this.day, required this.isDone, this.isToday = false});

  @override
  Widget build(BuildContext context) {
    const activeColor = Color.fromARGB(255, 249, 149, 11);
    final inactiveColor = Theme.of(context).colorScheme.onTertiary;
    const todayColor = activeColor;

    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday
                ? todayColor
                : (isDone ? activeColor : Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        const SizedBox(height: 6),
        CircleAvatar(
          radius: 14,
          backgroundColor: isDone ? activeColor : inactiveColor,
          child: isDone
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
      ],
    );
  }
}
