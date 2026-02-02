import 'package:flutter/material.dart';

class ScoreIndicator extends StatelessWidget {
  final String title;
  final IconData icon;

  const ScoreIndicator({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final barWidth = MediaQuery.of(context).size.width - 40;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colors.onPrimary),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: barWidth,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  colors: [Color(0xFF64A41C), Color(0xFFDF5F3C)],
                ),
              ),
            ),
            const _ScoreLabel(text: '0.10', color: Color(0xFF56AA17), left: 0),
            const _ScoreLabel(text: '1', color: Color(0xFFEC573F), right: 0),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Good',
              style: TextStyle(fontSize: 12, color: colors.onSecondary),
            ),
            Text(
              'Bad',
              style: TextStyle(fontSize: 12, color: colors.onSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScoreLabel extends StatelessWidget {
  final String text;
  final Color color;
  final double? left;
  final double? right;

  const _ScoreLabel({
    required this.text,
    required this.color,
    this.left,
    this.right,
  });

  static const double _pillWidth = 40;
  static const double _pillHeight = 20;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: -5,
      child: Container(
        width: _pillWidth,
        height: _pillHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
