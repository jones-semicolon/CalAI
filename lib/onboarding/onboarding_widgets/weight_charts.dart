import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';

class AnimatedWeightChart extends StatefulWidget {
  const AnimatedWeightChart({super.key});

  @override
  State<AnimatedWeightChart> createState() => _AnimatedWeightChartState();
}

class _AnimatedWeightChartState extends State<AnimatedWeightChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<FlSpot> traditional = const [
    FlSpot(0, 8),
    FlSpot(1, 6.5),
    FlSpot(2.5, 4),
    FlSpot(5, 10),
  ];

  final List<FlSpot> calAI = const [
    FlSpot(0, 8),
    FlSpot(2, 6.5),
    FlSpot(3.5, 1.5),
    FlSpot(5, 0),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<FlSpot> _getAnimatedSpots(List<FlSpot> points, double t) {
    final maxX = points.last.x;
    final animated = <FlSpot>[];

    for (final p in points) {
      if (p.x <= maxX * t) {
        animated.add(p);
      } else if (animated.isNotEmpty) {
        final last = animated.last;
        final progress = (maxX * t - last.x) / (p.x - last.x);
        final y = last.y + (p.y - last.y) * progress;
        animated.add(FlSpot(maxX * t, y));
        break;
      }
    }
    return animated;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            context.tr("Your weight"),
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          /// Chart + overlays
          Expanded(
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final t = _controller.value;
                    return LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 5,
                        minY: 0,
                        maxY: 10,
                        lineTouchData: LineTouchData(enabled: false),

                        /// Grid (horizontal only)
                        gridData: FlGridData(
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          horizontalInterval: 3,
                          getDrawingHorizontalLine: (_) =>
                              FlLine(color: Colors.black12, dashArray: [4, 4]),
                        ),

                        /// Titles
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 5,
                              getTitlesWidget: (value, _) {
                                if (value == 0) {
                                  return Transform.translate(
                                    offset: const Offset(25, 5), // move LEFT
                                    child: Text(context.tr("Month 1")),
                                  );
                                }

                                if (value == 5) {
                                  return Transform.translate(
                                    offset: const Offset(-25, 5), // move RIGHT
                                    child: Text(context.tr("Month 6")),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),

                        /// Bottom border only
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),

                        lineBarsData: [
                          /// 🔴 Traditional Diet
                          LineChartBarData(
                            spots: _getAnimatedSpots(traditional, t),
                            isCurved: true,
                            color: const Color.fromARGB(255, 221, 105, 105),
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                          ),

                          /// ⚫ Cal AI
                          LineChartBarData(
                            spots: _getAnimatedSpots(calAI, t),
                            isCurved: true,
                            color: theme.colorScheme.onPrimary,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              checkToShowDot: (spot, barData) {
                                final spots = barData.spots;
                                return spot == spots.first ||
                                    spot == spots.last;
                              },
                              getDotPainter: (spot, percent, barData, index) {
                                final theme = Theme.of(context);
                                return FlDotCirclePainter(
                                  radius: 5, // 10px diameter
                                  color: theme.scaffoldBackgroundColor,
                                  strokeWidth: 2,
                                  strokeColor: theme.colorScheme.onPrimary,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.onPrimary
                                      .withOpacity(0.1), // left
                                  Theme.of(context).scaffoldBackgroundColor
                                      .withOpacity(0.1), // right
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                /// Top-left legend
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.apple, size: 18),
                        const SizedBox(width: 6),
                        const Text(
                          "Cal AI",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            context.tr("Weight"),
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Top-right legend
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      context.tr("Traditional Diet"),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Text(
                context.tr(
                  "80% of Cal AI users maintain their weight loss even 6 months later",
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
