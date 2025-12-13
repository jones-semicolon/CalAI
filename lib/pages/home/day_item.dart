import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayItem extends StatefulWidget {
  const DayItem({super.key});

  @override
  State<DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  late final List<DateTime> monthDays;
  late final int activeDayIndex;
  late int activeWeekIndex;

  final PageController _weekController = PageController();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    monthDays = List.generate(
      lastDay.day,
      (i) => firstDay.add(Duration(days: i)),
    );

    activeDayIndex = now.day - 1;
    activeWeekIndex = activeDayIndex ~/ 7;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_weekController.hasClients) {
        _weekController.jumpToPage(activeWeekIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalWeeks = (monthDays.length / 7).ceil();
    final today = DateTime.now();

    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: _weekController,
        itemCount: totalWeeks,
        onPageChanged: (index) {
          setState(() => activeWeekIndex = index);
        },
        itemBuilder: (_, weekIndex) {
          if (weekIndex != activeWeekIndex) {
            return const SizedBox.shrink();
          }

          final start = weekIndex * 7;
          final end = (start + 7).clamp(0, monthDays.length);
          final weekDays = monthDays.sublist(start, end);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // 🔥 FIXED for large screens
              children: weekDays.map((day) {
                bool isSelected =
                    day.day == today.day &&
                    day.month == today.month &&
                    day.year == today.year;

                return _dayWrapper(
                  isSelected,
                  _dayItem(
                    DateFormat('EEE').format(day).substring(0, 3),
                    day.day.toString(),
                    isSelected,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _dayWrapper(bool isActive, Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).appBarTheme.backgroundColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  Widget _dayItem(String day, String num, bool selected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 28, // fixed circle size
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).hintColor,
              width: 2,
            ),
            color: selected
                ? Theme.of(context).appBarTheme.backgroundColor
                : Colors.transparent,
          ),
          child: Text(
            num,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
