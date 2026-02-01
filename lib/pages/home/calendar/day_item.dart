import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'calendar_provider.dart';

// ----------------------------
// Dashed Circle Painter
// ----------------------------

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

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

    final radius = size.width / 2;
    final circumference = 2 * pi * radius;

    final segmentLength = dashLength + spaceLength;
    final numberOfSegments =
    (circumference / segmentLength).floor().clamp(1, 9999);

    final adjustedSegmentLength = circumference / numberOfSegments;
    final dashAngle = dashLength / radius;
    final segmentAngle = adjustedSegmentLength / radius;

    for (int i = 0; i < numberOfSegments; i++) {
      final startAngle = i * segmentAngle;
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

// ----------------------------
// Circular Progress Ring Painter
// ----------------------------

class _ProgressRingPainter extends CustomPainter {
  final double progress; // 0..1
  final Color progressColor;
  final Color bgColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.progressColor,
    required this.bgColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    // background ring
    final bgPaint = Paint()
      ..color = bgColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // progress arc
    final progPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.bgColor != bgColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// ----------------------------
// DayItem Widget
// ----------------------------

class DayItem extends ConsumerStatefulWidget {
  final Set<String> progressDays; // has any progress
  final Set<String> overDays; // exceeded goal
  final Map<String, double> dailyCalories; // calories per dateId
  final double calorieGoal; // daily calorie goal

  /// ✅ controlled selected day ("YYYY-MM-DD")
  final String selectedDateId;

  /// ✅ callback when a day is tapped
  final ValueChanged<String> onDaySelected;

  const DayItem({
    super.key,
    required this.progressDays,
    required this.overDays,
    required this.dailyCalories,
    required this.calorieGoal,
    required this.selectedDateId,
    required this.onDaySelected,
  });

  @override
  ConsumerState<DayItem> createState() => _DayItemState();
}

class _DayItemState extends ConsumerState<DayItem> with AutomaticKeepAliveClientMixin {
  late PageController _weekController;
  final double _dayContainerSize = 35;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final calendar = ref.read(calendarProvider);
    _weekController = PageController(initialPage: calendar.initialWeekIndex);
  }

  @override
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }

  String _toDateId(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final calendar = ref.watch(calendarProvider);
    final totalWeeks = (calendar.monthDays.length / 7).ceil();

    return SizedBox(
      height: 70,
      child: PageView.builder(
        controller: _weekController,
        itemCount: totalWeeks,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, weekIndex) {
          final start = weekIndex * 7;
          final weekDays = calendar.monthDays.sublist(start, start + 7);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) {
                final dateId = _toDateId(day);
                final isToday = calendar.today.year == day.year &&
                    calendar.today.month == day.month &&
                    calendar.today.day == day.day;

                final isSelected = widget.selectedDateId == dateId;

                // Styling: Fade out days not in the current month
                final isCurrentMonth = day.month == calendar.today.month;
                final isFuture = day.isAfter(calendar.today);
                final isPast = day.isBefore(calendar.today) || isToday;

                return Opacity(
                  opacity: isCurrentMonth ? 1.0 : 0.3,
                  child: IgnorePointer(
                    ignoring: isFuture,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => widget.onDaySelected(dateId),
                      child: _DayContainer(
                        isActive: isSelected,
                        child: _DayDisplay(
                          day: day,
                          isSelected: isSelected,
                          isToday: isToday,
                          isPast: isPast,
                          containerSize: _dayContainerSize,
                          hasProgress: widget.progressDays.contains(dateId),
                          isOver: widget.overDays.contains(dateId),
                          calories: widget.dailyCalories[dateId] ?? 0,
                          goalCalories: widget.calorieGoal,
                        ),
                      ),
                    ),
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

// ----------------------------
// Helper Widgets
// ----------------------------

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

class _DayDisplay extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool isPast;
  final bool hasProgress;
  final bool isOver;
  final double calories;
  final double goalCalories;
  final double containerSize;

  const _DayDisplay({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isPast,
    required this.hasProgress,
    required this.isOver,
    required this.calories,
    required this.goalCalories,
    required this.containerSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dayAbbreviation = DateFormat('EEE').format(day);
    final dayNumber = day.day.toString();

    // ✅ Color priority:
    // Today highlight = black ring
    // Over = red
    // Has progress = green
    // None = grey ring/dash
    final ringColor = isToday
        ? Colors.black
        : isOver
        ? Colors.red
        : hasProgress
        ? Colors.green
        : theme.shadowColor.withOpacity(0.4);

    final textColor = isSelected ? theme.colorScheme.primary : theme.hintColor;

    final noProgress = calories <= 0;

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

        SizedBox(
          width: containerSize,
          height: containerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (noProgress && isPast)
                CustomPaint(
                  painter: _DashedCirclePainter(
                    color: theme.shadowColor.withOpacity(0.35),
                    strokeWidth: 2,
                  ),
                  child: const SizedBox.expand(),
                )
              else
                CustomPaint(
                  painter: _ProgressRingPainter(
                    progress: (goalCalories > 0) ? (calories / goalCalories) : 0,
                    progressColor: ringColor,
                    bgColor: theme.shadowColor.withOpacity(0.15),
                    strokeWidth: 2,
                  ),
                  child: const SizedBox.expand(),
                ),

              Text(
                dayNumber,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
