import 'package:calai/pages/progress/progress_data_provider.dart';
import 'package:calai/pages/progress/widgets/goal_progress_header.dart';
import 'package:calai/pages/progress/widgets/graph_card_decoration.dart';
import 'package:calai/pages/progress/widgets/progress_message_pill.dart';
import 'package:calai/pages/progress/widgets/time_range_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';

/// A widget that displays a line graph of the user's weight progress over time.
///
/// It includes a time range selector, a header showing goal progress, the line chart
/// itself, and a motivational message at the bottom.
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

  /// A helper to convert a month's integer value to its name (e.g., 1 -> "January").
  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    // This check prevents errors if the logs list is empty.
    if (logs.isEmpty) {
      return const Center(child: Text("No data available to display."));
    }

    final weights = logs.map<double>((e) => (e['weight'] as num).toDouble()).toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final range = maxWeight - minWeight;
    final yPadding = range * 0.1;

    return Column(
      children: [
        // The selector for changing the time range of the graph.
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
        // The main container for the graph card.
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: graphCardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalProgressHeader(progressPercent: progressPercent),
              const SizedBox(height: 16),
              // The LineChart is now built with data from cleaner, focused methods.
              SizedBox(
                height: 250,
                child: LineChart(
                  _buildChartData(context, minWeight, maxWeight, yPadding, range),
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

  // --- Chart Data Builder Methods --- //

  /// Constructs the main [LineChartData] by assembling data from helper methods.
  LineChartData _buildChartData(
      BuildContext context,
      double minWeight,
      double maxWeight,
      double yPadding,
      double range,
      ) {
    return LineChartData(
      minX: 0,
      maxX: (logs.length - 1).toDouble(),
      minY: minWeight - yPadding,
      maxY: maxWeight + yPadding,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: range / 4,
        getDrawingHorizontalLine: (_) => FlLine(
          dashArray: [4, 4],
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      titlesData: _buildTitlesData(context, minWeight, maxWeight),
      lineTouchData: _buildTouchData(context),
      lineBarsData: _buildLineBarsData(context),
    );
  }

  /// Configures the titles for the X and Y axes.
  FlTitlesData _buildTitlesData(BuildContext context, double minWeight, double maxWeight) {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
              style: const TextStyle(color: Color.fromARGB(255, 137, 137, 139)),
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
            if (i < 0 || i >= logs.length) return const SizedBox.shrink();
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
    );
  }

  /// Configures the interactive tooltip that appears on touch events.
  LineTouchData _buildTouchData(BuildContext context) {
    return LineTouchData(
      enabled: true,
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBorderRadius: const BorderRadius.all(Radius.circular(10)),
        getTooltipColor: (_) => Theme.of(context).focusColor.withOpacity(0.9),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final index = spot.x.toInt();
            final date = logs[index]['date'] as DateTime;
            final formattedDate = '${_monthName(date.month)} ${date.day}, ${date.year}';

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

  /// Defines the actual line on the chart, its styling, and the gradient below it.
  List<LineChartBarData> _buildLineBarsData(BuildContext context) {
    return [
      LineChartBarData(
        spots: List.generate(
          logs.length,
              (i) => FlSpot(i.toDouble(), logs[i]['weight']),
        ),
        isCurved: true,
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