import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// Custom Painter to draw a dashed circle border to simulate a "dotted" line.
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength = 3; // Length of the dash segment
  final double spaceLength = 4; // Length of the space segment

  _DashedCirclePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final double circumference = 2 * pi * radius;

    // Calculate how many segments fit and adjust for even spacing
    final double segmentLength = dashLength + spaceLength;
    final int numberOfSegments = (circumference / segmentLength).floor();

    // Ensure the total segments cover the circumference evenly
    final double adjustedSegmentLength = circumference / numberOfSegments;
    final double dashAngle = dashLength / radius;
    final double segmentAngle = adjustedSegmentLength / radius;

    for (int i = 0; i < numberOfSegments; i++) {
      final double startAngle = i * segmentAngle;

      // Draw a small arc/dash
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

class DayItem extends StatefulWidget {
  const DayItem({super.key});

  @override
  State<DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  late final List<DateTime> monthDays;
  late final int activeDayIndex;
  double dayContainerSize = 35;
  late int activeWeekIndex;

  final PageController _weekController = PageController();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    // Use the 1st day of the current month
    final firstDay = DateTime(now.year, now.month, 1);
    // Use the last day of the current month
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
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }

  // Helper function to check if a day is strictly in the past (before today)
  bool _isPastDay(DateTime date) {
    final now = DateTime.now();
    // Truncate to day for comparison
    final today = DateTime(now.year, now.month, now.day);
    final comparisonDate = DateTime(date.year, date.month, date.day);
    // Is strictly before today
    return comparisonDate.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    final totalWeeks = (monthDays.length / 7).ceil();
    final today = DateTime.now();

    return SizedBox(
      height: 70, // Fixed height for calendar
      child: PageView.builder(
        controller: _weekController,
        itemCount: totalWeeks,
        onPageChanged: (index) {
          setState(() => activeWeekIndex = index);
        },
        itemBuilder: (_, weekIndex) {
          final start = weekIndex * 7;
          final end = (start + 7).clamp(0, monthDays.length);
          final weekDays = monthDays.sublist(start, end);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) {
                // Check if the current day in the map loop is today
                bool isSelected =
                    day.day == today.day &&
                        day.month == today.month &&
                        day.year == today.year;

                return _dayWrapper(
                  isSelected,
                  _dayItem(
                    day, // Pass the full DateTime object
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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7.5),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).cardColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  // Updated to accept DateTime for past/present/future check
  Widget _dayItem(DateTime dayDate, String day, String num, bool selected) {
    final isPast = _isPastDay(dayDate);
    final borderColor = selected
        ? Theme.of(context).shadowColor
        : Theme.of(context).highlightColor;

    Widget dayNumberWidget = Text(
      num,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isPast || selected ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor,
      ),
    );

    Widget borderedContainer;

    if (isPast) {
      // Past Day: Use CustomPaint for dotted/dashed border
      borderedContainer = CustomPaint(
        painter: _DashedCirclePainter(color: Theme.of(context).shadowColor, strokeWidth: 1.5),
        child: Container(
          width: dayContainerSize,
          height: dayContainerSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Only color for past days, no solid border
            color: selected
                ? Theme.of(context).appBarTheme.backgroundColor
                : Colors.transparent,
          ),
          child: dayNumberWidget,
        ),
      );
    } else {
      // Present/Future Day: Use standard Container with solid border
      borderedContainer = Container(
        width: dayContainerSize,
        height: dayContainerSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? borderColor : Theme.of(context).shadowColor.withOpacity(0.5),
            width: 1.5,
          ),
          color: Colors.transparent,
        ),
        child: dayNumberWidget,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: isPast || selected ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor,
          ),
        ),
        borderedContainer,
      ],
    );
  }
}