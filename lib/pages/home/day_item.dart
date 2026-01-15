import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Custom Painter --- //

/// A custom painter that draws a dashed circle border.
///
/// This is used to visually distinguish past days in the calendar view,
/// giving them a "completed" or inactive look.
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  // Defines the visual style of the dashed line.
  final double dashLength = 3;
  final double spaceLength = 4;

  _DashedCirclePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final double circumference = 2 * pi * radius;

    // Calculate how many dash-space segments can fit into the circumference.
    final double segmentLength = dashLength + spaceLength;
    final int numberOfSegments = (circumference / segmentLength).floor();

    // Adjust segment length to ensure even spacing around the entire circle.
    final double adjustedSegmentLength = circumference / numberOfSegments;
    final double dashAngle = dashLength / radius;
    final double segmentAngle = adjustedSegmentLength / radius;

    for (int i = 0; i < numberOfSegments; i++) {
      final double startAngle = i * segmentAngle;
      // Draw a small arc segment to simulate a dash.
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

// --- Main Calendar Widget --- //

/// A horizontally scrollable weekly calendar widget.
///
/// It displays the days of the current month, highlighting the current day
/// and visually distinguishing past days.
class DayItem extends StatefulWidget {
  const DayItem({super.key});

  @override
  State<DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  late final List<DateTime> _monthDays;
  late final int _activeWeekIndex;
  final PageController _weekController = PageController();
  final double _dayContainerSize = 35;

  @override
  void initState() {
    super.initState();
    _initializeCalendar();
  }

  /// Sets up the calendar's date range and initial page.
  void _initializeCalendar() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    _monthDays = List.generate(
      lastDay.day,
          (i) => firstDay.add(Duration(days: i)),
    );

    // Calculate which week of the month is currently active.
    _activeWeekIndex = (now.day - 1) ~/ 7;

    // Jump to the current week after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_weekController.hasClients) {
        _weekController.jumpToPage(_activeWeekIndex);
      }
    });
  }

  @override
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }

  /// Checks if a given [date] is strictly before today.
  bool _isPastDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final comparisonDate = DateTime(date.year, date.month, date.day);
    return comparisonDate.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    final totalWeeks = (_monthDays.length / 7).ceil();

    return SizedBox(
      height: 70, // Fixed height allows the PageView to render.
      child: PageView.builder(
        controller: _weekController,
        itemCount: totalWeeks,
        itemBuilder: (_, weekIndex) {
          final start = weekIndex * 7;
          final end = (start + 7).clamp(0, _monthDays.length);
          final weekDays = _monthDays.sublist(start, end);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) {
                final today = DateTime.now();
                final isSelected = day.day == today.day && day.month == today.month;

                return _DayContainer(
                  isActive: isSelected,
                  child: _DayDisplay(
                    day: day,
                    isSelected: isSelected,
                    isPast: _isPastDay(day),
                    containerSize: _dayContainerSize,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

// --- Helper Widgets --- //

/// A container that wraps each day, highlighting it if it's the selected day.
class _DayContainer extends StatelessWidget {
  final bool isActive;
  final Widget child;

  const _DayContainer({required this.isActive, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7.5),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).cardColor : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}

/// Renders the visual representation of a single day.
///
/// This includes the day of the week abbreviation (e.g., "Mon") and the
/// numbered, circular container which changes style based on its state.
class _DayDisplay extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isPast;
  final double containerSize;

  const _DayDisplay({
    required this.day,
    required this.isSelected,
    required this.isPast,
    required this.containerSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayAbbreviation = DateFormat('EEE').format(day);
    final dayNumber = day.day.toString();

    final Color textColor = isPast || isSelected
        ? theme.colorScheme.primary
        : theme.hintColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dayAbbreviation,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        if (isPast)
        // Use the custom painter for past days.
          CustomPaint(
            painter: _DashedCirclePainter(color: theme.shadowColor, strokeWidth: 1.5),
            child: _DayNumberContainer(
              size: containerSize,
              dayNumber: dayNumber,
              textColor: textColor,
            ),
          )
        else
        // Use a standard container with a solid border for present/future days.
          Container(
            width: containerSize,
            height: containerSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? theme.shadowColor
                    : theme.shadowColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: _DayNumberText(dayNumber: dayNumber, textColor: textColor),
          ),
      ],
    );
  }
}

/// A simple container for the day number text, used by [_DayDisplay].
class _DayNumberContainer extends StatelessWidget {
  final double size;
  final String dayNumber;
  final Color textColor;

  const _DayNumberContainer({
    required this.size,
    required this.dayNumber,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: _DayNumberText(dayNumber: dayNumber, textColor: textColor),
    );
  }
}

/// The text widget for the day number, used by [_DayDisplay].
class _DayNumberText extends StatelessWidget {
  final String dayNumber;
  final Color textColor;

  const _DayNumberText({required this.dayNumber, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      dayNumber,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}