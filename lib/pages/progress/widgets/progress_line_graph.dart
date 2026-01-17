import 'dart:math';

import 'package:calai/pages/progress/widgets/goal_progress_header.dart';
import 'package:calai/pages/progress/widgets/graph_card_decoration.dart';
import 'package:calai/pages/progress/widgets/progress_message_pill.dart';
import 'package:calai/pages/progress/widgets/time_range_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

import '../progress_data_provider.dart';

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

  // ----------------------------
  // Helpers
  // ----------------------------

  String _shortMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  /// Creates a "nice" y-axis step size like: 0.2, 0.5, 1, 2, 5, 10...
  double _niceStep(double min, double max, {int lines = 5}) {
    final range = (max - min).abs();
    if (range == 0) return 1;

    final rawStep = range / (lines - 1);

    final magnitude = pow(10, (log(rawStep) / ln10).floor()).toDouble();
    final normalized = rawStep / magnitude;

    double niceNormalized;
    if (normalized < 1.5) {
      niceNormalized = 1;
    } else if (normalized < 3) {
      niceNormalized = 2;
    } else if (normalized < 7) {
      niceNormalized = 5;
    } else {
      niceNormalized = 10;
    }

    return niceNormalized * magnitude;
  }

  // ----------------------------
  // UI
  // ----------------------------

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(child: Text("No data available to display."));
    }

    final weights = logs
        .map<double>((e) => (e['weight'] as num).toDouble())
        .toList();

    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);

    // ✅ Force Y axis range to always be at least 5kg
    const double minRange = 3;

    double chartMin = minWeight;
    double chartMax = maxWeight;

    final currentRange = chartMax - chartMin;

    if (currentRange < minRange) {
      final extra = (minRange - currentRange) / 2;
      chartMin -= extra;
      chartMax += extra;
    } else {
      // Add padding when range is normal
      final pad = currentRange * 0.15;
      chartMin -= pad;
      chartMax += pad;
    }

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
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: graphCardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalProgressHeader(progressPercent: progressPercent),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: LineChart(
                  _buildChartData(context, chartMin, chartMax),
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

  // ----------------------------
  // Chart build
  // ----------------------------

  LineChartData _buildChartData(
      BuildContext context,
      double minY,
      double maxY,
      ) {
    final isSinglePoint = logs.length <= 1;

    final yStep = _niceStep(minY, maxY, lines: 5);
    final yMin = (minY / yStep).floor() * yStep;
    final yMax = (maxY / yStep).ceil() * yStep;

    final maxXValue = isSinglePoint ? 1.0 : (logs.length - 1).toDouble();

    return LineChartData(
      minX: 0,
      maxX: maxXValue + 0.1,

      minY: yMin,
      maxY: yMax,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: yStep,
        getDrawingHorizontalLine: (_) => FlLine(
          dashArray: [4, 4],
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      titlesData: _buildTitlesData(context, yStep),
      lineTouchData: _buildTouchData(context),
      lineBarsData: _buildLineBarsData(context),
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context, double yStep) {
    // ✅ control label density for x-axis
    final int len = logs.length;
    final int step = switch (len) {
      <= 2 => 2, // ✅ only first & last when 2 points
      <= 4 => 1,
      <= 8 => 2,
      <= 15 => 3,
      <= 30 => 6,
      _ => 10,
    };

    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

      // ✅ Left axis with decimals
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 44,
          interval: yStep,
          getTitlesWidget: (value, _) {
            return Text(
              value.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 137, 137, 139),
              ),
            );
          },
        ),
      ),

      // ✅ Bottom axis like Jan 14 / Jan 15 or Dec 05 style
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 30,
          getTitlesWidget: (v, _) {
            // ✅ only show labels on exact integer points
            if (v % 1 != 0) return const SizedBox.shrink();

            final i = v.toInt();
            if (i < 0 || i >= logs.length) return const SizedBox.shrink();

            // ✅ show only first & last when 2 points
            if (logs.length <= 2) {
              if (i != 0 && i != logs.length - 1) return const SizedBox.shrink();
            }

            final d = logs[i]['date'] as DateTime;

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${_shortMonth(d.month)} ${d.day.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color.fromARGB(255, 137, 137, 139),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  LineTouchData _buildTouchData(BuildContext context) {
    return LineTouchData(
      enabled: true,
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBorderRadius: const BorderRadius.all(Radius.circular(10)),
        getTooltipColor: (_) => Theme.of(context).focusColor.withOpacity(0.92),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            int index = spot.x.toInt();

            // ✅ if single-point mode, our 2nd spot is fake → map back to 0
            if (logs.length == 1) index = 0;

            final date = logs[index]['date'] as DateTime;
            final formattedDate =
                '${_monthName(date.month)} ${date.day}, ${date.year}';

            return LineTooltipItem(
              '${spot.y.toStringAsFixed(1)} kg',
              textAlign: TextAlign.left,
              TextStyle(
                color: Theme.of(context).canvasColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '\n$formattedDate',
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          }).toList();
        },
      ),
    );
  }

  List<LineChartBarData> _buildLineBarsData(BuildContext context) {
    final isSinglePoint = logs.length <= 1;

    // ✅ If only 1 point, create a straight line by faking a second point
    final spots = isSinglePoint
        ? [
      FlSpot(0, (logs[0]['weight'] as num).toDouble()),
      FlSpot(1, (logs[0]['weight'] as num).toDouble()),
    ]
        : List.generate(
      logs.length,
          (i) => FlSpot(
        i.toDouble(),
        (logs[i]['weight'] as num).toDouble(),
      ),
    );

    return [
      LineChartBarData(
        spots: spots,
        isCurved: !isSinglePoint,
        barWidth: 3,
        color: Theme.of(context).colorScheme.primary,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.5),
              Colors.transparent,
            ],
          ),
        ),
      ),
    ];
  }
}
