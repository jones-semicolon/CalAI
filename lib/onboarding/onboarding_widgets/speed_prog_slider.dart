import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';

class ProgSpeedSlider extends ConsumerStatefulWidget {
  final double initialWeight;
  final double lbPerKg;

  const ProgSpeedSlider({
    super.key,
    this.initialWeight = 0.8,
    required this.lbPerKg,
  });

  @override
  ConsumerState<ProgSpeedSlider> createState() => _ProgSpeedSliderState();
}

class _ProgSpeedSliderState extends ConsumerState<ProgSpeedSlider> {
  TextStyle get _labelStyle => const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: Color(0xFF4A4A4A),
  );

  double _convert(double kg, WeightUnit unit) => unit == WeightUnit.kg
      ? kg
      : double.parse((kg * widget.lbPerKg).toStringAsFixed(1));

  SpeedLevel _speedLevelFromKg(double kg) {
    if (kg <= 0.4) return SpeedLevel.slow;
    if (kg <= 1.0) return SpeedLevel.recommended;
    return SpeedLevel.aggressive;
  }

  String _bottomLabelFromKg(double kg) {
    if (kg <= 0.4) return 'Slow and Steady';
    if (kg <= 1.0) return 'Recommended';
    return 'You may feel very tired and develop loose skin';
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(userProvider).body.weightUnit;
    final speedKg = ref.watch(userProvider).goal.weeklyRate ?? 0.8;
    final theme = Theme.of(context).colorScheme.primary;

    final speedLevel = _speedLevelFromKg(speedKg);

    final iconsRow = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            FontAwesomeIcons.personWalking,
            color: speedLevel == SpeedLevel.slow ? Colors.orange : theme,
          ),
          Icon(
            FontAwesomeIcons.personRunning,
            color: speedLevel == SpeedLevel.recommended ? Colors.orange : theme,
          ),
          Icon(
            FontAwesomeIcons.personBiking,
            color: speedLevel == SpeedLevel.aggressive ? Colors.orange : theme,
          ),
        ],
      ),
    );

    final double minValue = _convert(0.1, unit);
    final double maxValue = _convert(1.5, unit);
    final double uiValue = _convert(speedKg.clamp(0.1, 1.5), unit);
    final String unitLabel = unit.value;

    final slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: theme,
        inactiveTrackColor: Theme.of(context).colorScheme.onTertiary,
        thumbShape: _ThumbShape(
          radius: 12,
          innerColor: Colors.black,
          outerRingColor: Theme.of(context).splashColor,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
        thumbColor: theme,
        overlayColor: Theme.of(context).colorScheme.tertiary,
      ),
      child: Slider(
        min: minValue,
        max: maxValue,
        value: uiValue,
        onChanged: (v) {
          double snap(double x) =>
              (x * 10).roundToDouble() / 10.0; // snap to 0.1

          final snapped = snap(v);

          final kg = unit == WeightUnit.kg ? snapped : snapped / widget.lbPerKg;

          final clampedKg = kg.clamp(0.1, 1.5);
          HapticFeedback.selectionClick();

          ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(goal: s.goal.copyWith(weeklyRate: clampedKg)));
        },
      ),
    );

    final labels = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_convert(0.1, unit).toStringAsFixed(1)} $unitLabel',
                style: _labelStyle,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${_convert(0.8, unit).toStringAsFixed(1)} $unitLabel',
                style: _labelStyle,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_convert(1.5, unit).toStringAsFixed(1)} $unitLabel',
                style: _labelStyle,
              ),
            ),
          ),
        ],
      ),
    );

    // FIXED: Updated background to linear gradient
    final pill = Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromARGB(255, 226, 234, 236),
            Color.fromARGB(255, 234, 233, 241),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          // 2. The Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _bottomLabelFromKg(speedKg),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: theme,
              ),
            ),
          ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconsRow,
          const SizedBox(height: 16),
          slider,
          const SizedBox(height: 8),
          labels,
          const SizedBox(height: 24),
          pill,
        ],
      ),
    );
  }
}

// Thumb
class _ThumbShape extends SliderComponentShape {
  final double radius;
  final Color innerColor;
  final Color outerRingColor;
  const _ThumbShape({
    required this.radius,
    required this.innerColor,
    required this.outerRingColor,
  });
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius + 2);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter? labelPainter,
    required RenderBox? parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double? textScaleFactor,
    required Size? sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    canvas.drawCircle(
      center,
      radius + 2,
      Paint()
        ..color = outerRingColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = innerColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      Colors.black45,
      2,
      true,
    );
  }
}
