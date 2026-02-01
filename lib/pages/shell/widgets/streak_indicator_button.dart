import 'package:calai/pages/home/widgets/day_streak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calai/data/global_data.dart';
/// A button widget that shows the user's current day streak and opens a
/// dialog with more details on tap.
class StreakIndicatorButton extends ConsumerWidget {
  const StreakIndicatorButton({super.key});

  String _toDateId(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  int _calculateStreak(Set<String> progressDays) {
    int streak = 0;

    final now = DateTime.now();
    // ✅ normalize date (remove time)
    DateTime cursor = DateTime(now.year, now.month, now.day);

    while (true) {
      final id = _toDateId(cursor);

      if (progressDays.contains(id)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
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
        final streak = _calculateStreak(global.progressDays);

        return _buildUI(
          context,
          streak: streak,
          colorScheme: colorScheme,
        );
      },
    );
  }

  Widget _buildUI(
      BuildContext context, {
        required int streak,
        required ColorScheme colorScheme,
        bool isLoading = false,
      }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black26,
          builder: (_) => const DayStreakDialog(),
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
            const SizedBox(width: 6),
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