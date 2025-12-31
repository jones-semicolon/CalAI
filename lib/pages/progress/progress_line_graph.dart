import 'package:calai/pages/progress/progress_page.dart';
import 'package:calai/pages/progress/widgets/goal_progress_header.dart';
import 'package:calai/pages/progress/widgets/graph_card_decoration.dart';
import 'package:calai/pages/progress/widgets/progress_message_pill.dart';
import 'package:calai/pages/progress/widgets/time_range_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final weights = logs
        .map<double>((e) => (e['weight'] as num).toDouble())
        .toList();

    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final range = maxWeight - minWeight;
    final yPadding = range * 0.1;
    final interval = (maxWeight - minWeight) / 4;

    return Column(
      children: [
        SegmentedSelector<TimeRange>(
          options: const [
            RangeOption(value: TimeRange.days90, label: '90 Days'),
            RangeOption(value: TimeRange.months6, label: '6 Months'),
            RangeOption(value: TimeRange.year1, label: '1 Year'),
            RangeOption(value: TimeRange.all, label: 'All time'),
          ],
          selected: selectedRange,
          onChanged: onRangeChanged,
        ),

        const SizedBox(height: 22),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: graphCardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalProgressHeader(progressPercent: progressPercent),

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
                        color: Theme.of(context).colorScheme.onTertiary,
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
                            if (value == minWeight || value == maxWeight) {
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
                        tooltipBorderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        getTooltipColor: (touchResponse) =>
                            Theme.of(context).focusColor.withOpacity(0.9),
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
                        color: Theme.of(context).colorScheme.primary,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.5),
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
                child: ProgressMessagePill(progressPercent: progressPercent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
