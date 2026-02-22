import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enums/user_enums.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/profile_widgets/unit_toggle.dart';

class WeightSelectionView extends ConsumerStatefulWidget {
  const WeightSelectionView({super.key});

  @override
  ConsumerState<WeightSelectionView> createState() => _WeightSelectionViewState();
}

class _WeightSelectionViewState extends ConsumerState<WeightSelectionView> {
  ThemeData get theme => Theme.of(context);

  // Conversion constants
  static const double _lbPerKg = 2.20462;

  // UI ruler config
  static const double _scale = 0.8;
  static const double _baseTickSpacing = 8.0;

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

    final user = ref.read(userProvider);

    double initial;
    if (user.goal.type == Goal.loseWeight) {
      initial = (user.body.currentWeight - 5).clamp(_minKg, _maxKg);
    } else if (user.goal.type == Goal.gainWeight) {
      initial = (user.body.currentWeight + 5).clamp(_minKg, _maxKg);
    } else {
      initial = user.body.currentWeight.clamp(_minKg, _maxKg);
    }

    _displayedWeightKg = ValueNotifier<double>(initial);

    _scrollCtrl = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToKg(initial);
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

  void _jumpToKg(double kg) {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.jumpTo(_offsetFromKg(kg));
  }

  void _animateToTick(int tick) {
    if (!_scrollCtrl.hasClients) return;

    _scrollCtrl.animateTo(
      tick * _tickSpacing,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  String _format(double kg, WeightUnit unit) {
    return unit == WeightUnit.kg
        ? kg.toStringAsFixed(1)
        : (kg * _lbPerKg).toStringAsFixed(1);
  }

  // ✅ snap ONCE after scroll ends (no jitter)
  void _snapToNearestTick() {
    if (!_scrollCtrl.hasClients) return;

    final tick = _tickFromOffset(_scrollCtrl.offset);
    final snappedKg = _kgFromTick(tick);

    _animateToTick(tick);

    // ✅ update UI
    _displayedWeightKg.value = snappedKg;

    // ✅ update provider only once
    ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(goal: s.goal.copyWith(targets: s.goal.targets.copyWith(targetWeight: snappedKg))));

    // ✅ optional haptic (only after snap)
    HapticFeedback.selectionClick();
  }

  // ----------------------------
  // goal label
  // ----------------------------

  String _goalLabel(double currentWeightKg, double targetKg) {
    if (targetKg > currentWeightKg) return 'Gain Weight';
    if (targetKg < currentWeightKg) return 'Lose Weight';
    return 'Maintain Weight';
  }

  // ----------------------------
  // UI
  // ----------------------------

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(userProvider).body.weightUnit;
    final user = ref.watch(userProvider);

    final horizontalPadding = 24.0;
    final width = MediaQuery.of(context).size.width - (horizontalPadding * 2);
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
            baseHeight = _tallTickHeight;      // Standard tall for .5
          } else {
            baseHeight = _shortTickHeight;     // Short for others
          }

          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: baseHeight * _scale + 10,
              width: 2.5,
              color: isWhole ? theme.colorScheme.primary : isHalf ? theme.colorScheme.secondary : Color.fromARGB(
                  255, 157, 157, 157),
            ),
          );
        },
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        UnitToggle(
        unit: unit,
        onChanged: (u) {
            ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(
              body: s.body.copyWith(weightUnit: u), // ✅ Correct: Returns User
            ));
          },
        ),

          const SizedBox(height: 30),

          // ✅ ONLY THIS TEXT REBUILDS (smooth)
          ValueListenableBuilder<double>(
            valueListenable: _displayedWeightKg,
            builder: (_, valueKg, _) {
              return Column(
                children: [
                  Text(
                    _goalLabel(user.body.currentWeight, valueKg),
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_format(valueKg, unit)} ${unit.value}',
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
                child: rulerList, // Pass the expensive list as a child
                builder: (context, child) {
                  final scrollOffset = _scrollCtrl.hasClients ? _scrollCtrl.offset : 0.0;

                  // Helper to find the CENTER of a tick slot
                  double getTickCenter(double kg) {
                    // Start of the list content + offset to specific Kg + half a tick width (center) - scrolled amount
                    return listPadding + _offsetFromKg(kg) + (_tickSpacing / 2) - scrollOffset;
                  }

                  final currentWeightCenter = getTickCenter(user.body.currentWeight);
                  final indicatorCenter = width / 2; // Fixed center of screen

                  final gradientLeft = math.min(currentWeightCenter, indicatorCenter);
                  final gradientWidth = (indicatorCenter - currentWeightCenter).abs();

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: rulerHeight,
                        width: double.infinity,
                        child: ClipRect(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // gradient current ↔ target
                              if (gradientWidth > 0)
                                Positioned(
                                  left: gradientLeft,
                                  bottom: 0,
                                  child: SizedBox(
                                    width: gradientWidth,
                                    height: _tallTickHeight * _scale + 30,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            theme.colorScheme.primary.withOpacity(0.25),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // Ruler List (passed from child to avoid rebuilds)
                              child!,

                              // center indicator
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

                      // current label
                      // ✅ FIXED: Accurately centered on the tick line using SizedBox + Center
                      Positioned(
                        left: currentWeightCenter - 50, // Center a 100px wide box on the tick
                        width: 100,
                        top: rulerHeight + 6,
                        child: Center(
                          child: Text(
                            '${_format(user.body.currentWeight, unit)} ${unit.value}',
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
                }
            ),
          ),
        ],
      ),
    );
  }
}