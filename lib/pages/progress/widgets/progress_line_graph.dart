import 'dart:math';
import 'package:calai/enums/food_enums.dart';
import 'package:calai/enums/user_enums.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:calai/l10n/l10n.dart';

import '../../../models/exercise_model.dart';
import '../../../providers/progress_data_provider.dart';
import 'package:calai/pages/progress/widgets/goal_progress_header.dart';
import 'package:calai/pages/progress/widgets/graph_card_decoration.dart';
import 'package:calai/pages/progress/widgets/progress_message_pill.dart';
import 'package:calai/pages/progress/widgets/time_range_selector.dart';

import '../screens/goal_picker_view.dart';
import '../screens/weight_picker_view.dart';

class ProgressGraph extends StatefulWidget {
  final TimeRange selectedRange;
  final ValueChanged<TimeRange> onRangeChanged;
  final List<WeightLog> logs;
  final double startedWeight;
  final double goalWeight;
  final double progressPercent;
  final MeasurementUnit? unitSystem;

  const ProgressGraph({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    required this.logs,
    required this.startedWeight,
    required this.goalWeight,
    required this.progressPercent,
    this.unitSystem,
  });

  @override
  State<ProgressGraph> createState() => _ProgressGraphState();
}

class _ProgressGraphState extends State<ProgressGraph> {
  // ✅ Track touch state to toggle colors
  bool _isTouched = false;

  // ----------------------------
  // Helpers
  // ----------------------------

  String _shortMonth(int month) => DateFormat('MMM').format(DateTime(2024, month));
  String _monthName(int month) => DateFormat('MMMM').format(DateTime(2024, month));

  double _niceStep(double min, double max, {int lines = 5}) {
    final range = (max - min).abs();
    if (range == 0) return 1;
    final rawStep = range / (lines - 1);
    final magnitude = pow(10, (log(rawStep) / ln10).floor()).toDouble();
    final normalized = rawStep / magnitude;

    double niceNormalized;
    if (normalized < 1.5) niceNormalized = 1;
    else if (normalized < 3) niceNormalized = 2;
    else if (normalized < 7) niceNormalized = 5;
    else niceNormalized = 10;

    return niceNormalized * magnitude;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // ✅ 1. Check if we have real data
    final bool hasNoData = widget.logs.isEmpty;
    final MeasurementUnit unitSystem = widget.unitSystem ?? MeasurementUnit.metric;

    final double goalWeightDisplay = unitSystem.metricToDisplay(widget.goalWeight);

    // ✅ 2. Create placeholder values if empty
    final List<double> weights = hasNoData
        ? [goalWeightDisplay, goalWeightDisplay]
        : widget.logs.map<double>((e) => unitSystem.metricToDisplay((e.weight as num).toDouble())).toList();

    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);

    const double minRange = 5; // Increased range to prevent 0-scale crashes
    double chartMin = minWeight;
    double chartMax = maxWeight;
    final currentRange = chartMax - chartMin;

    if (currentRange < minRange) {
      final extra = (minRange - currentRange) / 2;
      chartMin -= extra;
      chartMax += extra;
    } else {
      final pad = currentRange * 0.15;
      chartMin -= pad;
      chartMax += pad;
    }

    return Column(
      children: [
        SegmentedSelector<TimeRange>(
          options: [
            RangeOption(value: TimeRange.days90, label: l10n.ninetyDaysLabel),
            RangeOption(value: TimeRange.months6, label: l10n.sixMonthsLabel),
            RangeOption(value: TimeRange.year1, label: l10n.oneYearLabel),
            RangeOption(value: TimeRange.all, label: l10n.allTimeLabel),
          ],
          selected: widget.selectedRange,
          onChanged: widget.onRangeChanged,
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: graphCardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalProgressHeader(
                  progressPercent: widget.progressPercent,
                  onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalPickerView()))
              ),
              const SizedBox(height: 16),
              // ✅ 3. Stack the Chart with a "No Data" label if needed
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    LineChart(
                      _buildChartData(context, chartMin, chartMax, hasNoData),
                    ),
                    if (hasNoData)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10n.waitingForFirstLogLabel,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ProgressMessagePill(progressPercent: widget.progressPercent),
              ),
            ],
          ),
        ),
      ],
    );
  }

  LineChartData _buildChartData(BuildContext context, double minY, double maxY, bool hasNoData) {
    final isSinglePoint = widget.logs.length <= 1;
    final yStep = _niceStep(minY, maxY, lines: 5);
    final yMin = (minY / yStep).floor() * yStep;
    final yMax = (maxY / yStep).ceil() * yStep;

    // ✅ Keep maxXValue as an exact integer (the last index)
    final double maxXValue = isSinglePoint ? 1.0 : (widget.logs.length - 1).toDouble();

    return LineChartData(
      minX: 0,
      maxX: maxXValue, // ✅ Strict boundary: No +0.1 here
      minY: yMin,
      maxY: yMax,
      clipData: const FlClipData.all(),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: yStep,
        getDrawingHorizontalLine: (_) => FlLine(
          dashArray: [4, 4],
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      titlesData: _buildTitlesData(context, yStep, hasNoData),
      lineTouchData: _buildTouchData(context),
      lineBarsData: _buildLineBarsData(context, hasNoData),
    );
  }

  LineTouchData _buildTouchData(BuildContext context) {
    return LineTouchData(
      enabled: true,
      handleBuiltInTouches: true,
      // ✅ Toggle _isTouched state based on interaction
      touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
        if (!event.isInterestedForInteractions || response == null || response.lineBarSpots == null) {
          setState(() => _isTouched = false);
          return;
        }
        setState(() => _isTouched = true);
      },
      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((spotIndex) {
          return TouchedSpotIndicatorData(
            // 1. Style the vertical line
            FlLine(
              strokeWidth: 2, // Adjust thickness here
              // ✅ Setting gradient instead of color to create the fade effect
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.withOpacity(0.8), // Start color (solid-ish)
                  Colors.green.withOpacity(0.0), // End color (fully transparent)
                ],
              ),
              // ✅ dashArray is removed or set to null to make the line solid
              dashArray: null,
            ),
            // 2. Style the dot at the point
            FlDotData(
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.green, // Border around the dot
                );
              },
            ),
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
        tooltipBorderRadius: const BorderRadius.all(Radius.circular(10)),
        getTooltipColor: (_) => Theme.of(context).focusColor.withOpacity(0.92),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            int index = spot.x.toInt();
            if (widget.logs.length == 1) index = 0;

            double getDisplay(double val) {
              double converted = widget.unitSystem?.metricToDisplay(val) ?? val;
              // Rounds to 2 decimal places
              return double.parse(converted.toStringAsFixed(2));
            }

            final date = widget.logs[index].date;
            final formattedDate = '${_monthName(date.month)} ${date.day}, ${date.year}';

            return LineTooltipItem(
              '${getDisplay(spot.y)} ${widget.unitSystem?.weightLabel ?? MeasurementUnit.metric.weightLabel}',
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

  List<LineChartBarData> _buildLineBarsData(BuildContext context, bool hasNoData) {
    final Color activeColor = hasNoData
        ? Colors.grey.withOpacity(0.5) // Grey line if no data
        : (_isTouched ? Colors.green : Theme.of(context).colorScheme.primary);

    List<FlSpot> spots;

    double getDisplay(double val) {
      double converted = widget.unitSystem?.metricToDisplay(val) ?? val;
      // Rounds to 2 decimal places
      return double.parse(converted.toStringAsFixed(2));
    }

    if (hasNoData) {
      double target = getDisplay(widget.goalWeight);
      spots = [FlSpot(0, target), FlSpot(6, target)];
    } else if (widget.logs.length <= 1) {
      double weight = getDisplay(widget.logs[0].weight);
      spots = [FlSpot(0, weight), FlSpot(1, weight)];
    } else {
      spots = List.generate(
        widget.logs.length,
            (i) => FlSpot(i.toDouble(), getDisplay(widget.logs[i].weight)),
      );
    }

    return [
      LineChartBarData(
        spots: spots,
        isCurved: !hasNoData && widget.logs.length > 1,
        barWidth: 3,
        color: activeColor,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              activeColor.withOpacity(0.4),
              activeColor.withOpacity(0.0),
            ],
          ),
        ),
      ),
    ];
  }

  FlTitlesData _buildTitlesData(BuildContext context, double yStep, bool hasNoData) {
    final int totalLogs = widget.logs.length;

    final int skipInterval = switch (totalLogs) {
      <= 5 => 1,
      <= 10 => 2,
      <= 20 => 4,
      <= 60 => 7,
      _ => 14,
    };

    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 44,
          interval: yStep,
          getTitlesWidget: (value, _) => Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 137, 137, 139)),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: !hasNoData, // ✅ Only show date labels if we have logs
          interval: 1,
          reservedSize: 42,
          getTitlesWidget: (v, meta) {
            final int i = v.round();
            if (i < 0 || i >= widget.logs.length) return const SizedBox.shrink();

            if (i % skipInterval != 0) {
              return const SizedBox.shrink();
            }

            final d = widget.logs[i].date;

            return SideTitleWidget(
              meta: meta,
              space: 18,
              child: Transform.translate(
                offset: Offset(
                  i == 0
                      ? 0 // push first label right
                      : i == widget.logs.length - 1
                      ? -18 // push last label left
                      : 0,
                  0,
                ),
                child: Text(
                  "${_shortMonth(d.month)} ${d.day.toString().padLeft(2, '0')}",
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color.fromARGB(255, 137, 137, 139),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
