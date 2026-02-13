import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';

enum WeekRange { thisWeek, lastWeek, twoWeeksAgo, threeWeeksAgo }

class ProgressBarGraph extends StatefulWidget {
  final List<Map<String, dynamic>> calorieLogs;
  final double caloriesIntakePerDay;

  const ProgressBarGraph({
    super.key,
    required this.calorieLogs,
    required this.caloriesIntakePerDay,
  });

  @override
  State<ProgressBarGraph> createState() => _ProgressBarGraphState();
}

class _ProgressBarGraphState extends State<ProgressBarGraph> {
  WeekRange selectedRange = WeekRange.thisWeek;
  double _dayProtein(int index) {
    final log = filteredLogs.firstWhere(
      (e) => ((e['date'] as DateTime).weekday % 7) == index,
      orElse: () => {},
    );
    return log.isEmpty ? 0 : (log['protein'] as num).toDouble();
  }

  double _dayCarbs(int index) {
    final log = filteredLogs.firstWhere(
      (e) => ((e['date'] as DateTime).weekday % 7) == index,
      orElse: () => {},
    );
    return log.isEmpty ? 0 : (log['carbs'] as num).toDouble();
  }

  double _dayFats(int index) {
    final log = filteredLogs.firstWhere(
      (e) => ((e['date'] as DateTime).weekday % 7) == index,
      orElse: () => {},
    );
    return log.isEmpty ? 0 : (log['fats'] as num).toDouble();
  }

  // ---------------- FILTER LOGS BY WEEK ----------------

  List<Map<String, dynamic>> get filteredLogs {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    DateTime start;
    DateTime end;

    switch (selectedRange) {
      case WeekRange.thisWeek:
        start = startOfWeek;
        end = startOfWeek.add(const Duration(days: 7));
        break;
      case WeekRange.lastWeek:
        start = startOfWeek.subtract(const Duration(days: 7));
        end = startOfWeek;
        break;
      case WeekRange.twoWeeksAgo:
        start = startOfWeek.subtract(const Duration(days: 14));
        end = startOfWeek.subtract(const Duration(days: 7));
        break;
      case WeekRange.threeWeeksAgo:
        start = startOfWeek.subtract(const Duration(days: 21));
        end = startOfWeek.subtract(const Duration(days: 14));
        break;
    }

    return widget.calorieLogs.where((e) {
      final d = e['date'] as DateTime;
      return !d.isBefore(start) && d.isBefore(end);
    }).toList();
  }

  // ---------------- TOTAL & PERCENT ----------------

  double get totalCalories =>
      filteredLogs.fold(0.0, (s, e) => s + (e['calories'] as num).toDouble());

  double get percentageOfTarget {
    final target = widget.caloriesIntakePerDay * 7;
    if (target == 0) return 0;
    return (totalCalories / target) * 100;
  }

  // ---------------- BAR GROUPS ----------------

  List<BarChartGroupData> get barGroups {
    return List.generate(7, (i) {
      final log = filteredLogs.firstWhere(
        (e) => ((e['date'] as DateTime).weekday % 7) == i,
        orElse: () => {},
      );

      if (log.isEmpty) {
        return BarChartGroupData(x: i, barRods: []);
      }

      final double calories = (log['calories'] as num).toDouble();
      final double protein = (log['protein'] as num).toDouble();
      final double carbs = (log['carbs'] as num).toDouble();
      final double fats = (log['fats'] as num).toDouble();

      final double macroTotal = protein + carbs + fats;
      if (macroTotal == 0) {
        return BarChartGroupData(x: i, barRods: []);
      }

      final double fatsHeight = calories * (fats / macroTotal);
      final double carbsHeight = calories * (carbs / macroTotal);
      final double proteinHeight = calories * (protein / macroTotal);

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: calories,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            rodStackItems: [
              BarChartRodStackItem(
                0,
                fatsHeight,
                Color.fromARGB(255, 105, 152, 222),
              ),
              BarChartRodStackItem(
                fatsHeight,
                fatsHeight + carbsHeight,
                Color.fromARGB(255, 222, 154, 105),
              ),
              BarChartRodStackItem(
                fatsHeight + carbsHeight,
                fatsHeight + carbsHeight + proteinHeight,
                Color.fromARGB(255, 221, 105, 105),
              ),
            ],
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double maxCalories = filteredLogs.isEmpty
        ? widget.caloriesIntakePerDay
        : filteredLogs
              .map((e) => (e['calories'] as num).toDouble())
              .reduce((a, b) => a > b ? a : b);

    final double interval = maxCalories / 4;
    final double minY = -interval * 0.01;
    final double maxY = maxCalories + interval * 0.01;
    final motivationMessage = percentageOfTarget.round() <= 24
        ? context.tr("Getting started is the hardest part, You're ready for this!")
        : percentageOfTarget.round() >= 25 &&
              percentageOfTarget.round() <= 49
        ? context.tr("You're making progress - now's the time to keep pushing!")
        : percentageOfTarget.round() >= 50 &&
              percentageOfTarget.round() <= 74
        ? context.tr("You're dedication is paying off! Keep going.")
        : percentageOfTarget.round() >= 75 &&
              percentageOfTarget.round() <= 99
        ? context.tr("It's the final stretch! Push yourself!")
        : context.tr("You did it! Congratulations!");

    return Column(
      children: [
        _weekSelectorCard(context),
        const SizedBox(height: 22),

        // ================= GRAPH CARD =================
        Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            bottom: 16,
            right: 30,
          ),
          decoration: _decoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- HEADER ----------
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('Total Calories'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            totalCalories.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            ' ${context.tr('cals')}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          percentageOfTarget <= 24
                              ? RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: Color.fromARGB(
                                            255,
                                            203,
                                            77,
                                            55,
                                          ),
                                          size: 18,
                                        ),
                                      ),
                                      const WidgetSpan(
                                        child: SizedBox(width: 4),
                                      ),
                                      TextSpan(
                                        text:
                                            '${percentageOfTarget.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            203,
                                            77,
                                            55,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.arrow_upward,
                                          color: Color.fromARGB(
                                            255,
                                            32,
                                            141,
                                            26,
                                          ),
                                          size: 18,
                                        ),
                                      ),
                                      const WidgetSpan(
                                        child: SizedBox(width: 4),
                                      ),
                                      TextSpan(
                                        text:
                                            '${percentageOfTarget.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            32,
                                            141,
                                            26,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------- BAR CHART ----------
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    minY: minY,
                    maxY: maxY,
                    barGroups: barGroups,
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: interval,
                      getDrawingHorizontalLine: (_) => FlLine(
                        dashArray: [4, 4],
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    titlesData: FlTitlesData(
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
                            return Text(
                              v.round().toString(),
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
                            final days = [
                              context.tr('Sun'),
                              context.tr('Mon'),
                              context.tr('Tue'),
                              context.tr('Wed'),
                              context.tr('Thu'),
                              context.tr('Fri'),
                              context.tr('Sat'),
                            ];
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
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => Theme.of(context).canvasColor,
                        tooltipBorderRadius: BorderRadius.all(Radius.circular(10)),
                        tooltipPadding: const EdgeInsets.all(10),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final days = [
                            context.tr('Sun'),
                            context.tr('Mon'),
                            context.tr('Tue'),
                            context.tr('Wed'),
                            context.tr('Thu'),
                            context.tr('Fri'),
                            context.tr('Sat'),
                          ];

                          final calories = rod.toY;
                          final protein = _dayProtein(group.x);
                          final carbs = _dayCarbs(group.x);
                          final fats = _dayFats(group.x);

                          return BarTooltipItem(
                            '${context.tr('Calories')}: ${calories.toStringAsFixed(0)}\n'
                            '${context.tr('Protein')}: ${protein.toStringAsFixed(0)}g\n'
                            '${context.tr('Carbs')}: ${carbs.toStringAsFixed(0)}g\n'
                            '${context.tr('Fats')}: ${fats.toStringAsFixed(0)}g\n',
                            TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.left,
                            children: [
                              TextSpan(
                                text: days[group.x], 
                                style:  TextStyle(
                                  color: Color.fromARGB(255, 136, 136, 136),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ---------- LEGEND ----------
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Legend(
                    icon: Icons.set_meal_outlined,
                    color: Color.fromARGB(255, 221, 105, 105),
                    label: 'Protein',
                  ),
                  SizedBox(width: 12),
                  _Legend(
                    icon: Icons.bubble_chart,
                    color: Color.fromARGB(255, 222, 154, 105),
                    label: 'Carbs',
                  ),
                  SizedBox(width: 12),
                  _Legend(
                    icon: Icons.oil_barrel,
                    color: Color.fromARGB(255, 105, 152, 222),
                    label: 'Fats',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------- MOTIVATION ----------
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
                    motivationMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 139, 28),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  // ================= TIME SELECTOR CARD =================

  Widget _weekSelectorCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColorLight,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final ranges = WeekRange.values;
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
                    margin: const EdgeInsets.all(4),
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
                        onTap: () => setState(() => selectedRange = r),
                        child: Center(
                          child: Text(
                            _rangeText(context, r),
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
    );
  }

  String _rangeText(BuildContext context, WeekRange r) {
    switch (r) {
      case WeekRange.thisWeek:
        return context.tr('This Week');
      case WeekRange.lastWeek:
        return context.tr('Last Week');
      case WeekRange.twoWeeksAgo:
        return context.tr('2 wks ago');
      case WeekRange.threeWeeksAgo:
        return context.tr('3 wks ago');
    }
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  const _Legend({required this.color, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          context.tr(label),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
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
