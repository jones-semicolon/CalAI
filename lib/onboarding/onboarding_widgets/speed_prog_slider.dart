import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calai/l10n/app_strings.dart';
import '../../data/user_data.dart';
import 'weight_picker/weight_enums.dart';
import 'weight_picker/weight_unit_provider.dart';

enum SpeedLevel { slow, recommended, aggressive }

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
    final unit = ref.watch(weightUnitProvider);
    final speedKg = ref.watch(userProvider).progressSpeed;
    final notifier = ref.read(userProvider.notifier);
    final theme = Theme.of(context).colorScheme.onPrimary;

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
    final String unitLabel = unit == WeightUnit.kg ? 'kg' : 'lbs';

    final slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: theme,
        inactiveTrackColor: Theme.of(context).appBarTheme.surfaceTintColor,
        thumbShape: const _ThumbShape(
          radius: 12,
          innerColor: Colors.black,
          outerRingColor: Colors.white,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
        thumbColor: theme,
        overlayColor: Theme.of(context).splashColor,
      ),
      child: Slider(
        min: minValue,
        max: maxValue,
        value: uiValue,
        divisions: unit == WeightUnit.kg
            ? ((1.5 - 0.1) / 0.1).round()
            : ((3.3 - 0.1) / 0.1).round(),
        onChanged: (v) {
          final kg = unit == WeightUnit.kg ? v : v / widget.lbPerKg;
          if (mounted) notifier.setProgressSpeed(kg); 
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

    final pill = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: RepaintBoundary(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Stack(
            children: [
              Container(color: Theme.of(context).appBarTheme.surfaceTintColor),
              Positioned(
                right: -40,
                top: -30,
                child: _pillBlob(
                  color: const ui.Color.fromARGB(45, 236, 158, 129),
                  size: 120,
                ),
              ),
              Positioned(
                left: -300,
                bottom: -40,
                child: _pillBlob(
                  color: const Color.fromARGB(45, 194, 177, 218),
                  size: 500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 14,
                ),
                alignment: Alignment.center,
                child: Text(
                  context.tr(_bottomLabelFromKg(speedKg)),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: theme,
                  ),
                ),
              ),
            ],
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

// Blurred pill blob
Widget _pillBlob({required Color color, required double size}) =>
    RepaintBoundary(
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: 100, sigmaY: 40),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              radius: 1.0,
              stops: const [0.0, 0.4, 0.75, 1.0],
              colors: [
                color.withOpacity(0.9),
                color.withOpacity(0.15),
                color.withOpacity(0.9),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
