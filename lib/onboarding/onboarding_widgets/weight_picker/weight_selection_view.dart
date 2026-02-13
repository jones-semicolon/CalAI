import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/user_data.dart';
import 'unit_toggle.dart';
import 'weight_enums.dart';
import 'weight_unit_provider.dart';

class WeightSelectionView extends ConsumerStatefulWidget {
  const WeightSelectionView({super.key});

  @override
  ConsumerState<WeightSelectionView> createState() =>
      _WeightSelectionViewState();
}

class _WeightSelectionViewState extends ConsumerState<WeightSelectionView> {
  ThemeData get theme => Theme.of(context);

  // Conversion constants
  static const double _lbPerKg = 2.20462; // 1 kg = 2.20462 lbs

  // UI constants
  static const double _scale = 0.8;
  static const double _baseTickSpacing = 12.0;
  static const double _shortTickHeight = 16.0;
  static const double _tallTickHeight = 32.0;
  static const double _indicatorTopExtra = 18.0;
  static const double _minKg = 5.0;
  static const double _maxKg = 300.0;
  static const double _stepKg = 0.1;

  // State
  late double _displayedWeightKg; // Always stored in kg
  late ScrollController _scrollCtrl;
  int _lastTick = -1;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    // Determine initial displayed weight
    // if (user.targetWeight > 0) {
    //   _displayedWeightKg = user.targetWeight;
    // } else {
    final goal = user.goal.toLowerCase();
    if (goal == 'lose weight') {
      _displayedWeightKg = user.weight - 5;
    } else if (goal == 'gain weight') {
      _displayedWeightKg = user.weight + 5;
    } else {
      _displayedWeightKg = user.weight; // maintain
    }
    // }

    _scrollCtrl = ScrollController()..addListener(_onScroll);

    // Update provider and scroll after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).setTargetWeight(_displayedWeightKg);
      _jumpTo(_displayedWeightKg);
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  int get _ticks => ((_maxKg - _minKg) / _stepKg).round();
  double get _tickSpacing => _baseTickSpacing * _scale;

  // Goal logic (always in kg)
  GoalDirection get _goal {
    final currentWeight = ref.read(userProvider).weight;
    if (_displayedWeightKg > currentWeight) return GoalDirection.gain;
    if (_displayedWeightKg < currentWeight) return GoalDirection.lose;
    return GoalDirection.maintain;
  }

  String get _goalLabel {
    switch (_goal) {
      case GoalDirection.gain:
        return 'Gain Weight';
      case GoalDirection.lose:
        return 'Lose Weight';
      case GoalDirection.maintain:
        return 'Maintain Weight';
    }
  }

  // Convert kg to scroll offset
  double _offsetFromKg(double kg) {
    return ((kg - _minKg).clamp(0, _maxKg - _minKg) / _stepKg) * _tickSpacing;
  }

  // Scroll listener
  void _onScroll() {
    final idx = (_scrollCtrl.offset / _tickSpacing).round();
    if (idx != _lastTick) {
      _lastTick = idx;
      setState(() {
        _displayedWeightKg = (_minKg + idx * _stepKg).clamp(_minKg, _maxKg);
      });

      // Update provider (always in kg)
      ref.read(userProvider.notifier).setTargetWeight(_displayedWeightKg);
    }
  }

  void _jumpTo(double kg) {
    _scrollCtrl.jumpTo(_offsetFromKg(kg));
  }

  String _format(double kg, WeightUnit unit) => unit == WeightUnit.kg
      ? kg.toStringAsFixed(1)
      : (kg * _lbPerKg).toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(weightUnitProvider);
    final user = ref.watch(userProvider);

    final width = MediaQuery.of(context).size.width;
    final sidePadding = width / 2 - _tickSpacing / 2;
    final double totalHeight = 110;
    final double rulerHeight = totalHeight / 1.5;

    final double indicatorX = width / 2;

    final double currentX = sidePadding + _offsetFromKg(user.weight);

    final double currentViewX =
        currentX - (_scrollCtrl.hasClients ? _scrollCtrl.offset : 0);

    // Gradient bounds
    final double gradientLeft = math.min(currentViewX, indicatorX);

    final double gradientWidth = (indicatorX - currentViewX).abs();


    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UnitToggle(
          unit: ref.watch(weightUnitProvider),
          onChanged: (u) {
            ref.read(weightUnitProvider.notifier).state = u;
          },
        ),

        const SizedBox(height: 30),

        Text(
          context.tr(_goalLabel),
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          '${_format(_displayedWeightKg, unit)} ${unit == WeightUnit.kg ? 'kg' : 'lbs'}',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        SizedBox(height: 20),

        SizedBox(
          height: totalHeight,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // === Ruler + Gradient ===
              SizedBox(
                height: rulerHeight,
                width: double.infinity,
                child: ClipRect(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Gradient bar
                      if (gradientWidth > 0)
                        Positioned(
                          left: gradientLeft,
                          bottom: 0,
                          child: SizedBox(
                            width: gradientWidth,
                            height: _tallTickHeight * _scale + 20,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    theme.colorScheme.onPrimary.withOpacity(
                                      0.5,
                                    ),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Ruler ticks
                      ListView.builder(
                        controller: _scrollCtrl,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: sidePadding + 10,
                        ),
                        itemCount: _ticks,
                        itemBuilder: (_, i) {
                          final isMajor = i % 5 == 0;
                          return SizedBox(
                            width: _tickSpacing - 2,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height:
                                    (isMajor
                                            ? _tallTickHeight + 5
                                            : _shortTickHeight) *
                                        _scale +
                                    10,
                                width: 2.5,
                                color: isMajor
                                    ? theme.colorScheme.onPrimary
                                    : theme.shadowColor,
                              ),
                            ),
                          );
                        },
                      ),

                      // Center indicator line
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height:
                              (_tallTickHeight + _indicatorTopExtra) * _scale +
                              30,
                          width: 2.5,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: currentViewX - 15,
                top: rulerHeight + 5,
                child: Text(
                  '${_format(user.weight, unit)} ${unit == WeightUnit.kg ? 'kg' : 'lbs'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
