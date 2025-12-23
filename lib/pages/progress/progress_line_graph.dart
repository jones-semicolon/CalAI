import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'progress_page.dart';

class ProgressGraph extends StatelessWidget {
  final TimeRange selectedRange;
  final ValueChanged<TimeRange> onRangeChanged;
  final List<Map<String, dynamic>> logs;
  final double startedWeight;
  final double goalWeight;
  final double progressPercent;

  const ProgressGraph({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    required this.logs,
    required this.startedWeight,
    required this.goalWeight,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    final List<double> weights = logs
        .map<double>((e) => (e['weight'] as num).toDouble())
        .toList();

    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final double range = maxWeight - minWeight;
    final double yPadding = range * 0.1;

    final double minY = (minWeight - yPadding).toDouble();
    final double maxY = (maxWeight + yPadding).toDouble();

    final double interval = (maxY - minY) / 4;

    String _monthName(int month) {
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return months[month - 1];
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColorLight,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final ranges = TimeRange.values;
              final itemWidth = constraints.maxWidth / ranges.length;
              final selectedIndex = ranges.indexOf(selectedRange);

              return SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      left: selectedIndex * itemWidth,
                      width: itemWidth,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      children: ranges.map((r) {
                        final selected = r == selectedRange;

                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onRangeChanged(r),
                            child: Center(
                              child: Text(
                                _rangeText(r),
                                style: TextStyle(
                                  color: selected
                                      ? Theme.of(context).colorScheme.onTertiary
                                      : Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 22),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: _decoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Goal Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Handle edit goal action
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).unselectedWidgetColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 18,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${progressPercent.round()}%',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'of goal',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.edit,
                              size: 18,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (logs.length - 1).toDouble(),
                    minY: minWeight - yPadding,
                    maxY: maxWeight + yPadding,

                    borderData: FlBorderData(show: false),

                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: interval,
                      getDrawingHorizontalLine: (_) => FlLine(
                        dashArray: [4, 4],
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),

                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 34,
                          getTitlesWidget: (value, _) {
                            if (value == minY || value == maxY) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 137, 137, 139),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 30,
                          getTitlesWidget: (v, _) {
                            final i = v.toInt();
                            if (i < 0 || i >= logs.length) {
                              return const SizedBox.shrink();
                            }
                            final d = logs[i]['date'] as DateTime;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${d.month}/${d.day}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color.fromARGB(255, 137, 137, 139),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBorderRadius: BorderRadius.all(Radius.circular(10)),
                        getTooltipColor: (touchResponse) => Theme.of(context).focusColor.withOpacity(0.9),
                        getTooltipItems: (touchedSpots) {
                          interval;
                          return touchedSpots.map((spot) {
                            final index = spot.x.toInt();
                            final date = logs[index]['date'] as DateTime;

                            final formattedDate =
                                '${_monthName(date.month)} ${date.day}, ${date.year}';

                            return LineTooltipItem(
                              '${spot.y.toStringAsFixed(1)} kg',
                              textAlign: TextAlign.left,
                              TextStyle(
                                color: Theme.of(
                                  context,
                                ).canvasColor, // weight color
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(
                                  text: '\n$formattedDate',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).canvasColor, // date color
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          logs.length,
                          (i) => FlSpot(i.toDouble(), logs[i]['weight']),
                        ),
                        isCurved: true,
                        barWidth: 3,
                        color: Theme.of(context).colorScheme.onPrimary,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.onPrimary.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                  child: Text(
                    progressPercent.round() <= 24
                        ? "Getting started is the hardest part, You're ready for this!"
                        : progressPercent.round() >= 25 &&
                              progressPercent.round() <= 49
                        ? "You're making progress—now's the time to keep pushing!"
                        : progressPercent.round() >= 50 &&
                              progressPercent.round() <= 74
                        ? "You're dedication is paying off! Keep going."
                        : progressPercent.round() >= 75 &&
                              progressPercent.round() <= 99
                        ? "It's the final stretch! Push yourself!"
                        : "You did it! Congratulations!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 139, 28),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }

  String _rangeText(TimeRange r) {
    switch (r) {
      case TimeRange.days90:
        return '90 Days';
      case TimeRange.months6:
        return '6 Months';
      case TimeRange.year1:
        return '1 Year';
      case TimeRange.all:
        return 'All time';
    }
  }
}

BoxDecoration _decoration(BuildContext context) => BoxDecoration(
  borderRadius: BorderRadius.circular(25),
  color: Theme.of(context).scaffoldBackgroundColor,
  border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2),
  boxShadow: [
    BoxShadow(
      color: Theme.of(context).shadowColor.withOpacity(0.2),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ],
);
