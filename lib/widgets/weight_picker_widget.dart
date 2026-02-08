import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enums/user_enums.dart';
import '../../../providers/user_provider.dart';
import '../onboarding/onboarding_widgets/weight_picker/unit_toggle.dart';

class WeightPicker extends ConsumerStatefulWidget {
  final double initialWeight;
  final double referenceWeight;
  final WeightUnit unit;
  final Function(double kg) onWeightChanged;
  final String Function(double current, double selected)? labelBuilder;
  final bool showReferenceLine;

  const WeightPicker({
    super.key,
    required this.initialWeight,
    required this.referenceWeight,
    required this.unit,
    required this.onWeightChanged,
    this.labelBuilder,
    this.showReferenceLine = true,
  });

  @override
  ConsumerState<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends ConsumerState<WeightPicker> {
  ThemeData get theme => Theme.of(context);

  // Conversion constants
  static const double _lbPerKg = 2.20462;

  // UI ruler config
  static const double _scale = 0.8;
  static const double _baseTickSpacing = 12.0;

  static const double _shortTickHeight = 16.0;
  static const double _tallTickHeight = 32.0;
  static const double _indicatorTopExtra = 18.0;

  static const double _minKg = 5.0;
  static const double _maxKg = 300.0;
  static const double _stepKg = 0.1;

  double get _tickSpacing => _baseTickSpacing * _scale;

  int get _ticks => ((_maxKg - _minKg) / _stepKg).round();

  late final ScrollController _scrollCtrl;

  // ✅ smooth UI updates without rebuilding whole widget
  late final ValueNotifier<double> _displayedWeightKg;

  // ✅ prevents spam
  int _lastTick = -1;
  Timer? _snapTimer;

  @override
  void initState() {
    super.initState();

    _displayedWeightKg = ValueNotifier<double>(widget.initialWeight);
    _scrollCtrl = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollCtrl.jumpTo(_offsetFromKg(widget.initialWeight));
    });
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _scrollCtrl.dispose();
    _displayedWeightKg.dispose();
    super.dispose();
  }

  // ----------------------------
  // helpers
  // ----------------------------

  double _offsetFromKg(double kg) {
    return ((kg - _minKg).clamp(0, _maxKg - _minKg) / _stepKg) * _tickSpacing;
  }

  int _tickFromOffset(double offset) {
    final idx = (offset / _tickSpacing).round();
    return idx.clamp(0, _ticks);
  }

  double _kgFromTick(int tick) {
    return (_minKg + tick * _stepKg).clamp(_minKg, _maxKg).toDouble();
  }

  String _format(double kg) => widget.unit == WeightUnit.kg
      ? kg.toStringAsFixed(1)
      : (kg * _lbPerKg).toStringAsFixed(1);

  // ✅ snap ONCE after scroll ends (no jitter)
  void _snapToNearestTick() {
    if (!_scrollCtrl.hasClients) return;
    final tick = _tickFromOffset(_scrollCtrl.offset);
    final snappedKg = _kgFromTick(tick);

    _scrollCtrl.animateTo(tick * _tickSpacing, duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic);
    _displayedWeightKg.value = snappedKg;
    widget.onWeightChanged(snappedKg);
    HapticFeedback.selectionClick();
  }
  // ----------------------------
  // UI
  // ----------------------------

  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;

    final width = MediaQuery.of(context).size.width;
    final totalHeight = 110.0;
    final rulerHeight = totalHeight / 1.5;

    // Center the list items so index 0 is at center screen when offset is 0
    final sidePadding = width / 2 - _tickSpacing / 2;
    final listPadding = sidePadding;

    // Create the ruler list once to avoid rebuilding it on every animation frame
    final rulerList = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // ✅ update display ONLY when tick changes
        if (notification is ScrollUpdateNotification) {
          final tick = _tickFromOffset(_scrollCtrl.offset);
          if (tick != _lastTick) {
            _lastTick = tick;
            _displayedWeightKg.value = _kgFromTick(tick);
          }
        }

        // ✅ snap after scroll end
        if (notification is ScrollEndNotification) {
          _snapTimer?.cancel();
          _snapTimer = Timer(
            const Duration(milliseconds: 40),
            _snapToNearestTick,
          );
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollCtrl,
        scrollDirection: Axis.horizontal,

        // ✅ FIXED: Added itemExtent for performance and preventing micro-jitters
        itemExtent: _tickSpacing,

        physics: const ClampingScrollPhysics(),

        padding: EdgeInsets.symmetric(horizontal: listPadding),
        itemCount: _ticks + 1,
        itemBuilder: (_, i) {
          // ✅ Hierarchy Logic:
          // i % 10 == 0  --> Whole Numbers (x.0) -> Tallest
          // i % 5 == 0   --> Half Steps (x.5)    -> Medium
          // Else         --> Minor Steps (x.1)   -> Short

          final isWhole = i % 10 == 0;
          final isHalf = i % 5 == 0;

          double baseHeight;
          if (isWhole) {
            baseHeight = _tallTickHeight + 12; // Extra tall for whole numbers
          } else if (isHalf) {
            baseHeight = _tallTickHeight; // Standard tall for .5
          } else {
            baseHeight = _shortTickHeight; // Short for others
          }

          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: baseHeight * _scale + 10,
              width: 2.5,
              color: isWhole
                  ? theme.colorScheme.primary
                  : isHalf
                  ? theme.colorScheme.secondary
                  : Color.fromARGB(255, 157, 157, 157),
            ),
          );
        },
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UnitToggle(
          unit: unit,
          onChanged: (u) {
            ref.read(userProvider.notifier).updateLocal(
                  (state) => state.copyWith(
                body: state.body.copyWith(weightUnit: u),
              ),
            );
          },
        ),
        const SizedBox(height: 30),

        // ✅ ONLY THIS TEXT REBUILDS (smooth)
        ValueListenableBuilder<double>(
          valueListenable: _displayedWeightKg,
          builder: (_, valueKg, __) {
            return Column(
              children: [
                if (widget.labelBuilder != null)
                  Text(
                    widget.labelBuilder!(widget.referenceWeight, valueKg),
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  '${_format(valueKg)} ${widget.unit.value}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: totalHeight,
          width: double.infinity,
          // ✅ FIXED: AnimatedBuilder ensures overlay elements move exactly with scroll
          child: AnimatedBuilder(
            animation: _scrollCtrl,
            child: rulerList,
              builder: (context, child) {
                final scrollOffset = _scrollCtrl.hasClients ? _scrollCtrl.offset : _offsetFromKg(widget.initialWeight);

                // 1. Calculate the horizontal position of any KG value on the screen
                double getPositionOfKg(double kg) {
                  return listPadding + _offsetFromKg(kg) + (_tickSpacing / 2) - scrollOffset;
                }

                // 2. The positions we care about
                final referenceX = getPositionOfKg(widget.referenceWeight); // The 72.7 kg tick
                final needleX = width / 2;                                   // The center red/black line

                // 3. Define the shadow box
                final gradientWidth = (needleX - referenceX).abs();
                final gradientLeft = math.min(referenceX, needleX);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: rulerHeight,
                      child: ClipRect(
                        child: Stack(
                          children: [
                            // ✅ THE FIXED SHADOW
                            if (widget.showReferenceLine && gradientWidth > 1)
                              Positioned(
                                left: gradientLeft,
                                bottom: 0,
                                child: Container(
                                  width: gradientWidth,
                                  height: rulerHeight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        theme.colorScheme.primary.withOpacity(0.15),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            child!, // The Ruler List

                            // Center Needle
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: (_tallTickHeight + _indicatorTopExtra) * _scale + 30,
                                width: 2.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Reference Label (72.7 kg)
                    if (widget.showReferenceLine)
                      Positioned(
                        left: referenceX - 50,
                        width: 100,
                        top: rulerHeight + 6,
                        child: Center(
                          child: Text(
                            '${_format(widget.referenceWeight)} ${widget.unit.value}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }          ),
        ),
      ],
    );
  }
}
