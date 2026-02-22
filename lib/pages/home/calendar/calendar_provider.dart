// Define a small data class for the calendar state
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarState {
  final List<DateTime> monthDays;
  final int initialWeekIndex;
  final DateTime today;

  CalendarState({
    required this.monthDays,
    required this.initialWeekIndex,
    required this.today,
  });
}

final calendarProvider = Provider<CalendarState>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final firstDayOfMonth = DateTime(now.year, now.month, 1);
  final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

  final leadingDaysCount = firstDayOfMonth.weekday % 7;
  final List<DateTime> allDays = [];

  if (leadingDaysCount > 0) {
    final _ = firstDayOfMonth.subtract(const Duration(days: 1));
    for (int i = leadingDaysCount - 1; i >= 0; i--) {
      allDays.add(firstDayOfMonth.subtract(Duration(days: i + 1)));
    }
  }

  // 2. Add current month days
  allDays.addAll(List.generate(
    lastDayOfMonth.day,
        (i) => firstDayOfMonth.add(Duration(days: i)),
  ));

  // 3. Add trailing days from the next month to complete the 7-day row
  final trailingDaysCount = 7 - (allDays.length % 7);
  if (trailingDaysCount < 7) {
    final nextMonthFirstDay = DateTime(now.year, now.month + 1, 1);
    for (int i = 0; i < trailingDaysCount; i++) {
      allDays.add(nextMonthFirstDay.add(Duration(days: i)));
    }
  }

  // 4. Calculate initial index
  // We find which week 'today' falls into within the expanded list
  final todayIndex = allDays.indexWhere((d) =>
  d.year == today.year && d.month == today.month && d.day == today.day);
  final initialWeekIndex = (todayIndex >= 0) ? (todayIndex ~/ 7) : 0;

  return CalendarState(
    monthDays: allDays,
    initialWeekIndex: initialWeekIndex,
    today: today,
  );
});