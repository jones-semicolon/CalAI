import 'package:flutter/material.dart';

import '../../../widgets/animated_number.dart';

/// A card widget to display a specific nutrient's status, including its
/// current progress against a goal, shown with an animated circular indicator.
class CalorieCard extends StatelessWidget {
  final String title;
  final num nutrients;
  final num progress;
  final Color color;
  final IconData icon;
  final bool isTap;
  final String? unit;

  const CalorieCard({
    super.key,
    required this.title,
    required this.nutrients,
    required this.progress,
    required this.color,
    required this.icon,
    this.unit,
    this.isTap = false,
  });

  bool get overEat {
    return progress > nutrients;
  }

  @override
  Widget build(BuildContext context) {
    final num valueInt = isTap ? progress : (nutrients - progress);

    // The TextStyle is defined here to be passed down, preserving the original style.
    final valueStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Theme.of(context).colorScheme.primary,
      letterSpacing: 0,
    );

    return Container(
      // height: 145,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Theme.of(context).splashColor, width: 1),
      ),
      // The main layout is a Column, now composed of smaller, focused widgets.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            valueInt: valueInt,
            isTap: isTap,
            nutrients: nutrients,
            unit: unit,
            valueStyle: valueStyle,
          ),
          _Title(
            title: title,
            isTap: isTap,
            overEat: overEat,
          ),
          // A fixed SizedBox is used to preserve the original spacing.
          SizedBox(height: 10),
          _ProgressIndicator(
            progress: progress,
            nutrients: nutrients,
            color: color,
            icon: icon,
          ),
        ],
      ),
    );
  }
}

// --- Private Helper Widgets --- //

/// Displays the top section with the main animated number and unit.
class _Header extends StatelessWidget {
  final num valueInt;
  final bool isTap;
  final num nutrients;
  final String? unit;
  final TextStyle valueStyle;

  const _Header({
    required this.valueInt,
    required this.isTap,
    required this.nutrients,
    this.unit,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final value = valueInt.abs().round();
    // This widget's structure is identical to the original implementation.
    return SizedBox(
      width: double.infinity,
      height: 30, // Keep this fixed to prevent the card from jumping
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          style: valueStyle,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.start,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // First digit slide
              AnimatedSlideNumber(
                value: value.toString().split("").first,
                style: valueStyle,
                reverse: isTap,
              ),
              // Use AnimatedSize HERE to smooth the width change of the text
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  // LayoutBuilder keeps the Row from snapping width
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    alignment: Alignment.centerLeft,
                    children: [...previousChildren, if (currentChild != null) currentChild],
                  ),
                  child: Text(
                    isTap
                        ? value.toString().substring(1)
                        : "${value.toString().substring(1)}$unit",
                    key: ValueKey(isTap),
                    // REMOVE style: valueStyle here.
                    // Let it inherit from AnimatedDefaultTextStyle to enable font tweening.
                  ),
                ),
              ),
              Baseline(
                baseline: 18,
                baselineType: TextBaseline.alphabetic,
                child: AnimatedSlideNumber(
                  value: isTap ? " /${nutrients.round()}$unit" : "",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  reverse: isTap,
                  inAnim: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays the title of the card (e.g., "Protein eaten").
class _Title extends StatelessWidget {
  final String title;
  final bool isTap;
  final bool overEat;

  const _Title({required this.title, required this.isTap, required this.overEat});

  @override
  Widget build(BuildContext context) {
    // This widget preserves the original Row and Flexible structure.
    return Row(
      children: [
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            // TextSpan styles are preserved from the original code.
            text: TextSpan(
              style: const TextStyle(fontSize: 12),
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: " ${isTap ? 'eaten' : (overEat ? 'over' : 'left')}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Displays the circular progress indicator and the central icon.
class _ProgressIndicator extends StatelessWidget {
  final num progress;
  final num nutrients;
  final Color color;
  final IconData icon;

  const _ProgressIndicator({
    required this.progress,
    required this.nutrients,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // This widget's structure is identical to the original implementation.
    return Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: 0,
                  end: (progress / nutrients).clamp(0.0, 1.0),
                ),
                builder: (context, value, _) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Theme.of(context).splashColor,
                  color: color,
                ),
              ),
            ),
            Container(
              height: 27,
              width: 27,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 15, color: color),
            ),
          ],
        ),
      ),
    );
  }
}