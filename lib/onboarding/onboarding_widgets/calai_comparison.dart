import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';

class ComparisonCard extends StatefulWidget {
  const ComparisonCard({super.key});

  @override
  State<ComparisonCard> createState() => _ComparisonCardState();
}

class _ComparisonCardState extends State<ComparisonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _leftBarAnim;
  late final Animation<double> _leftLabelAnim;
  late final Animation<double> _rightBarAnim;
  late final Animation<double> _rightLabelAnim;
  late final Animation<double> _bottomLeftDescAnim;
  late final Animation<double> _bottomRightDescAnim;

  static const _totalDuration = Duration(milliseconds: 3500);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _totalDuration)
      ..forward();

    const easeOut = Curves.easeOut;

    _leftBarAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.25, curve: Curves.bounceOut),
    );

    _leftLabelAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.50, 0.55, curve: easeOut),
    );

    _rightBarAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.26, 0.46, curve: easeOut),
    );

    _rightLabelAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.50, 0.55, curve: easeOut),
    );

    _bottomLeftDescAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.60, 0.70, curve: easeOut),
    );

    _bottomRightDescAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.72, 0.82, curve: easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final secondary = colors.secondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth / 4;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: secondary,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(50, 23, 144, 160),
                          Color(0x00FFFFFF),
                          Color.fromARGB(50, 175, 75, 117),
                        ],
                        stops: [0.0, 0.0, 1.0],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _ProgressColumn(
                              title: 'Without\nCal AI',
                              barWidth: barWidth,
                              targetFillFraction: 0.30,
                              fillColor:
                                  colors.surfaceContainerHighest,
                              valueLabel: '20%',
                              barAnimation: _leftBarAnim,
                              labelAnimation: _leftLabelAnim,
                              textColor: colors.onPrimary,
                            ),
                            const SizedBox(width: 20),
                            _ProgressColumn(
                              title: 'With\nCal AI',
                              barWidth: barWidth,
                              targetFillFraction: 1.0,
                              fillColor: colors.onPrimary,
                              valueLabel: '2X',
                              barAnimation: _rightBarAnim,
                              labelAnimation: _rightLabelAnim,
                              textColor: theme.scaffoldBackgroundColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _AnimatedText(
                          animation: _bottomLeftDescAnim,
                          text: 'Cal AI makes it easy and holds',
                        ),
                        _AnimatedText(
                          animation: _bottomRightDescAnim,
                          text: 'you accountable',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AnimatedText extends StatelessWidget {
  const _AnimatedText({
    required this.animation,
    required this.text,
  });

  final Animation<double> animation;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween(begin: const Offset(0, 0.2), end: Offset.zero),
        ),
        child: Text(
          context.tr(text),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _ProgressColumn extends StatelessWidget {
  const _ProgressColumn({
    required this.title,
    required this.barWidth,
    required this.targetFillFraction,
    required this.fillColor,
    required this.valueLabel,
    required this.barAnimation,
    required this.labelAnimation,
    required this.textColor,
  });

  final String title;
  final double barWidth;
  final double targetFillFraction;
  final Color fillColor;
  final String valueLabel;
  final Color textColor;
  final Animation<double> barAnimation;
  final Animation<double> labelAnimation;

  @override
  Widget build(BuildContext context) {
    final currentFraction =
        barAnimation.value * targetFillFraction * 0.70;

    return Container(
      width: barWidth,
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 6,
              right: 6,
              child: Text(
                context.tr(title),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: currentFraction,
                child: Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: labelAnimation,
                child: SlideTransition(
                  position: labelAnimation.drive(
                    Tween(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ),
                  ),
                  child: Text(
                    valueLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
