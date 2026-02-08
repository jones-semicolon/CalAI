import 'dart:math';

import 'package:calai/enums/food_enums.dart';
import 'package:calai/pages/progress/widgets/progress_bar_graph_logic.dart';
import 'package:calai/pages/progress/widgets/graph_card_decoration.dart';
import 'package:calai/pages/progress/widgets/graph_header.dart';
import 'package:calai/pages/progress/widgets/graph_legend.dart';
import 'package:calai/pages/progress/widgets/progress_message_pill.dart';
import 'package:calai/pages/progress/widgets/time_range_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/nutrition_model.dart';

/// A widget that displays a bar graph of the user's calorie intake over time.
///
/// This widget is purely for presentation. It uses a [ProgressBarGraphLogic]
/// class to handle all data processing and chart generation, and then lays out
/// the UI using smaller, focused sub-widgets.
class ProgressBarGraph extends StatefulWidget {
  final List<DailyNutrition> dailyNutrition;
  final double caloriesIntakePerDay;

  const ProgressBarGraph({
    super.key,
    required this.dailyNutrition,
    required this.caloriesIntakePerDay,
  });

  @override
  State<ProgressBarGraph> createState() => _ProgressBarGraphState();
}

class _ProgressBarGraphState extends State<ProgressBarGraph> {
  WeekRange _selectedRange = WeekRange.thisWeek;

  @override
  Widget build(BuildContext context) {
    final logic = ProgressBarGraphLogic(
      allLogs: widget.dailyNutrition,
      selectedRange: _selectedRange,
    );

    final filteredLogs = logic.filteredLogs;
    final percentage = logic.percentageOfTarget(widget.caloriesIntakePerDay);

    // 1. Safe Max Calculation using fold
    final double maxCaloriesFromLogs = filteredLogs.fold<double>(
        0.0,
            (maxVal, e) => e.kc > maxVal ? e.kc.toDouble() : maxVal
    );

    // 2. Determine max Y - Ensure we never have a 0 max to avoid division errors
    final double targetCals = widget.caloriesIntakePerDay > 0 ? widget.caloriesIntakePerDay : 2000;
    final double maxYValue = max(maxCaloriesFromLogs, targetCals);

    // 3. Ensure interval is at least 1
    final double rawInterval = maxYValue / 4;
    final double interval = rawInterval <= 0 ? 500 : rawInterval;

    final double minY = 0;
    final double maxY = max(maxYValue, interval * 4);

    return Column(
      children: [
        SegmentedSelector<WeekRange>(
          options: const [
            RangeOption(value: WeekRange.thisWeek, label: 'This Week'),
            RangeOption(value: WeekRange.lastWeek, label: 'Last Week'),
            RangeOption(value: WeekRange.twoWeeksAgo, label: '2 wks ago'),
            RangeOption(value: WeekRange.threeWeeksAgo, label: '3 wks ago'),
          ],
          selected: _selectedRange,
          onChanged: (value) => setState(() => _selectedRange = value),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            bottom: 16,
            right: 30,
          ),
          decoration: graphCardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GraphHeader(
                title: 'Total Calories',
                totalValue: logic.totalCalories,
                unit: 'cals',
                percentage: percentage,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ClipRect(
                  child: BarChart(
                      BarChartData(
                        minY: minY,
                        maxY: maxY * 1.15,
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: logic.getBarGroups(),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          drawVerticalLine: false,
                          horizontalInterval: interval,
                          checkToShowHorizontalLine: (value) {
                            if (value == 0) return true;
                  
                            final ratio = value / interval;
                            return (ratio - ratio.round()).abs() < 0.001;
                          },
                          getDrawingHorizontalLine: (_) => FlLine(
                            dashArray: [6, 6],
                            strokeWidth: 1.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        titlesData: _buildTitlesData(interval),
                        barTouchData: _buildTouchData(context, logic),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GraphLegend(
                    icon: Icons.set_meal_outlined,
                    color: Color.fromARGB(255, 221, 105, 105),
                    label: 'Protein',
                  ),
                  SizedBox(width: 12),
                  GraphLegend(
                    icon: Icons.bubble_chart,
                    color: Color.fromARGB(255, 222, 154, 105),
                    label: 'Carbs',
                  ),
                  SizedBox(width: 12),
                  GraphLegend(
                    icon: Icons.oil_barrel,
                    color: Color.fromARGB(255, 105, 152, 222),
                    label: 'Fats',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ProgressMessagePill(progressPercent: percentage),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  FlTitlesData _buildTitlesData(double interval) {
    return FlTitlesData(
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: interval,
          reservedSize: 40,
          getTitlesWidget: (v, _) {
            if (v < 0) return const SizedBox.shrink();

            // ✅ show ONLY exact tick labels to prevent duplicates at top
            final ratio = v / interval;
            final isTick = (ratio - ratio.round()).abs() < 0.001;
            if (!isTick) return const SizedBox.shrink();

            return Text(
              v.floor().toString(),
              style: const TextStyle(
                fontSize: 11,
                color: Color.fromARGB(255, 137, 137, 139),
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (v, _) {
            const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            if (v < 0 || v > 6) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                days[v.toInt()],
                style: const TextStyle(
                  fontSize: 11,
                  color: Color.fromARGB(255, 136, 136, 136),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BarTouchData _buildTouchData(BuildContext context, ProgressBarGraphLogic logic) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => Theme.of(context).canvasColor,
        tooltipBorderRadius: const BorderRadius.all(Radius.circular(10)),
        tooltipPadding: const EdgeInsets.all(10),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

          final calories = rod.toY;
          final protein = logic.getDayProtein(group.x);
          final carbs = logic.getDayCarbs(group.x);
          final fats = logic.getDayFats(group.x);

          return BarTooltipItem(
            'Calories: ${calories.toStringAsFixed(0)}\n'
            'Protein: ${protein.toStringAsFixed(0)}g\n'
            'Carbs: ${carbs.toStringAsFixed(0)}g\n'
            'Fats: ${fats.toStringAsFixed(0)}g\n',
            TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textAlign: TextAlign.left,
            children: [
              TextSpan(
                text: days[group.x],
                style: const TextStyle(
                  color: Color.fromARGB(255, 136, 136, 136),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
