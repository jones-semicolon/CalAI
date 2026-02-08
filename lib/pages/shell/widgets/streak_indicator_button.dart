import 'package:calai/pages/home/widgets/day_streak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/global_provider.dart';

/// A button widget that shows the user's current day streak and opens a
/// dialog with more details on tap.
class StreakIndicatorButton extends ConsumerWidget {
  final bool? isDisabled; // ✅ Added callback
  const StreakIndicatorButton({super.key, this.isDisabled});

  int _calculateStreak(List<bool> streakWeek) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final globalAsync = ref.watch(globalDataProvider);

    return globalAsync.when(
      loading: () => _buildUI(
        context,
        streak: 0,
        colorScheme: colorScheme,
        isLoading: true,
      ),
      error: (_, _) => _buildUI(
        context,
        streak: 0,
        colorScheme: colorScheme,
      ),
      data: (global) {
        final streak = _calculateStreak(_buildWeekStreak(global.progressDays));

        return _buildUI(
          context,
          streak: streak,
          progressDays: _buildWeekStreak(global.progressDays),
          isDisabled: isDisabled,
          colorScheme: colorScheme,
        );
      },
    );
  }

  Widget _buildUI(
      BuildContext context, {
        required int streak,
        required ColorScheme colorScheme,
        List<bool>? progressDays,
        bool? isDisabled = false, // ✅ Use the passed callback
        bool isLoading = false,
      }) {
    return GestureDetector(
      onTap: () {
        if (isDisabled == true) return;
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black26,
          builder: (_) => DayStreakDialog(dayStreak: progressDays!),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department, color: Colors.orange),
            const SizedBox(width: 3),
            Text(
              isLoading ? '0' : '$streak',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


List<bool> _buildWeekStreak(Set<String> progressDays) {
  final daysOrder = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday'
  ];

  return List.generate(7, (i) {
    final dayName = daysOrder[i];

    return progressDays.contains(dayName);
  });
}