import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnimatedWeightChart extends StatefulWidget {
  const AnimatedWeightChart({super.key});

  @override
  State<AnimatedWeightChart> createState() => _AnimatedWeightChartState();
}

class _AnimatedWeightChartState extends State<AnimatedWeightChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Original final points for each line
  final List<FlSpot> traditional = [
    FlSpot(0, 8),
    FlSpot(1.5, 6),
    FlSpot(3, 7),
    FlSpot(5, 9),
  ];

  final List<FlSpot> calAI = [
    FlSpot(0, 8),
    FlSpot(2, 6),
    FlSpot(4, 3),
    FlSpot(5, 2),
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
    // t = 0.0 -> start, t = 1.0 -> full chart
    double maxX = points.last.x;
    List<FlSpot> animated = [];

    for (var p in points) {
      if (p.x <= maxX * t) {
        // fully visible
        animated.add(p);
      } else if (animated.isNotEmpty) {
        // interpolate last segment partially
        FlSpot last = animated.last;
        double progress = (maxX * t - last.x) / (p.x - last.x);
        double y = last.y + (p.y - last.y) * progress;
        animated.add(FlSpot(maxX * t, y));
        break; // don't add remaining points yet
      }
    }

    return animated;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        double t = _controller.value; // 0 -> 1
        return LineChart(
          LineChartData(
            minX: 0,
            maxX: 5,
            minY: 0,
            maxY: 10,
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: 2,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: Colors.black12, dashArray: [6, 6]),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5,
                  getTitlesWidget: (value, _) {
                    if (value == 0) return const Text("Month 1");
                    if (value == 5) return const Text("Month 6");
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: _getAnimatedSpots(traditional, t),
                isCurved: true,
                color: Colors.redAccent,
                barWidth: 3,
                dotData: FlDotData(show: false),
              ),
              LineChartBarData(
                spots: _getAnimatedSpots(calAI, t),
                isCurved: true,
                color: Colors.black,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
