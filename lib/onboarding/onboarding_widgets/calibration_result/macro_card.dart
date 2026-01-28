import 'dart:math';
import 'package:flutter/material.dart';
import 'app_constants.dart';

class MacroCard extends StatelessWidget {
  final String title;
  final String value;
  final double progress;
  final Color progressColor;
  final IconData icon;
  final VoidCallback? onTap;

  const MacroCard({
    super.key,
    required this.title,
    required this.value,
    required this.progress,
    required this.progressColor,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double shrink =
        screenWidth < 430 ? (430 - screenWidth) : 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double tileSide = constraints.maxWidth;

          const double padding = AppSpacing.medium;
          final double usable =
              max(0, tileSide - padding * 2);

          const double baseMin = 72;
          const double baseMax = 110;

          final double minSize =
              max(56, baseMin - shrink);
          final double maxSize =
              max(minSize + 12, baseMax - shrink);

          final double circleSize =
              usable.clamp(minSize, maxSize);

          final double strokeWidth =
              max(4.5, 6 - shrink * 0.02);

          return Container(
            padding: const EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg(context),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: AppColors.border(context),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ───────────── Header ─────────────
                Row(
                  children: [
                    CircleAvatar(
                      radius: AppRadius.badge,
                      backgroundColor:
                          AppColors.circularBg(context),
                      child: Icon(
                        icon,
                        size: 16,
                        color: progressColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.onPrimary(context),
                        ),
                      ),
                    ),
                  ],
                ),

                // ───────────── Circle  ─────────────
                Center(
                  child: SizedBox(
                    width: circleSize,
                    height: circleSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background ring
                        CustomPaint(
                          size: Size(circleSize, circleSize),
                          painter: _RingPainter(
                            progress: 1,
                            color:
                                AppColors.circularBg(context),
                            strokeWidth: strokeWidth,
                          ),
                        ),
                        CustomPaint(
                          size: Size(circleSize, circleSize),
                          painter: _RingPainter(
                            progress: progress,
                            color: progressColor,
                            strokeWidth: strokeWidth,
                          ),
                        ),
                        // Value
                        Text(
                          value,
                          style: AppTextStyles.value.copyWith(
                            fontSize:
                                max(12, 16 - shrink * 0.05),
                            color:
                                AppColors.onPrimary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ───────────── Footer ─────────────
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.onPrimary(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
