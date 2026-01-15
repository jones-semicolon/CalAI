import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// 1. This is your main data file containing the "correct" WeightUnit
import '../../../data/health_data.dart';
import '../../../data/user_data.dart';
class WeightSelectionView extends ConsumerStatefulWidget {
  const WeightSelectionView({super.key});

  @override
  ConsumerState<WeightSelectionView> createState() => _WeightSelectionViewState();
}

enum GoalDirection { gain, lose, maintain }

class _WeightSelectionViewState extends ConsumerState<WeightSelectionView> {
  ThemeData get theme => Theme.of(context);

  // Constants
  static const double _lbPerKg = 2.20462;
  static const double _scale = 0.8;
  static const double _baseTickSpacing = 12.0;
  static const double _shortTickHeight = 16.0;
  static const double _tallTickHeight = 32.0;
  static const double _indicatorTopExtra = 18.0;
  static const double _minKg = 5.0;
  static const double _maxKg = 300.0;
  static const double _stepKg = 0.1;

  late double _displayedWeightKg;
  late ScrollController _scrollCtrl;
  int _lastTick = -1;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    // Initial logic based on your new Enums
    if (user.goal == Goal.loseWeight) {
      _displayedWeightKg = user.weight - 5;
    } else if (user.goal == Goal.gainWeight) {
      _displayedWeightKg = user.weight + 5;
    } else {
      _displayedWeightKg = user.weight;
    }

    _scrollCtrl = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).update((s) => s.copyWith(targetWeight: _displayedWeightKg));
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

  GoalDirection get _goalDirection {
    final currentWeight = ref.read(userProvider).weight;
    if (_displayedWeightKg > currentWeight) return GoalDirection.gain;
    if (_displayedWeightKg < currentWeight) return GoalDirection.lose;
    return GoalDirection.maintain;
  }

  String get _goalLabel {
    switch (_goalDirection) {
      case GoalDirection.gain: return 'Gain Weight';
      case GoalDirection.lose: return 'Lose Weight';
      case GoalDirection.maintain: return 'Maintain Weight';
    }
  }

  double _offsetFromKg(double kg) => ((kg - _minKg).clamp(0, _maxKg - _minKg) / _stepKg) * _tickSpacing;

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final idx = (_scrollCtrl.offset / _tickSpacing).round();
    if (idx != _lastTick) {
      _lastTick = idx;
      final newWeight = (_minKg + idx * _stepKg).clamp(_minKg, _maxKg);

      setState(() {
        _displayedWeightKg = newWeight;
      });

      // Update provider
      ref.read(userProvider.notifier).update((s) => s.copyWith(targetWeight: newWeight));
    }
  }

  void _jumpTo(double kg) {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(_offsetFromKg(kg));
    }
  }

  String _format(double kg, WeightUnit unit) {
    return unit == WeightUnit.kg ? kg.toStringAsFixed(1) : (kg * _lbPerKg).toStringAsFixed(1);
  }

  final weightUnitProvider = StateProvider<WeightUnit>((ref) {
    return WeightUnit.kg;
  });

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(weightUnitProvider);
    final user = ref.watch(userProvider);
    final width = MediaQuery.of(context).size.width;

    final sidePadding = width / 2;
    const double totalHeight = 110;
    const double rulerHeight = totalHeight / 1.5;

    // Current Weight Indicator Position
    final currentX = sidePadding + _offsetFromKg(user.weight);
    final indicatorX = width / 2;
    final scrollOffset = _scrollCtrl.hasClients ? _scrollCtrl.offset : _offsetFromKg(_displayedWeightKg);
    final currentViewX = currentX - scrollOffset;

    // Gradient bar logic
    final barLeft = math.min(currentViewX, indicatorX);
    final barWidth = (indicatorX - currentViewX).abs();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Unit Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("kg", style: TextStyle(color: theme.colorScheme.onPrimary)),
              Switch(
                value: unit == WeightUnit.lbs,
                onChanged: (isLbs) {
                  ref.read(weightUnitProvider.notifier).state = isLbs ? WeightUnit.lbs : WeightUnit.kg;
                },
              ),
              Text("lbs", style: TextStyle(color: theme.colorScheme.onPrimary)),
            ],
          ),
        ),

        const SizedBox(height: 30),

        Text(
          _goalLabel,
          style: TextStyle(fontSize: 16, color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
        ),

        Text(
          '${_format(_displayedWeightKg, unit)} ${unit == WeightUnit.kg ? 'kg' : 'lbs'}',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary),
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: totalHeight,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Gradient for the distance between current and target
              if (barWidth > 0)
                Positioned(
                  left: barLeft,
                  top: 0,
                  child: Container(
                    width: barWidth,
                    height: rulerHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [theme.colorScheme.onPrimary.withOpacity(0.3), Colors.transparent],
                      ),
                    ),
                  ),
                ),

              // Ruler
              ListView.builder(
                controller: _scrollCtrl,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                itemCount: _ticks + 1,
                itemBuilder: (_, i) {
                  final isMajor = i % 10 == 0;
                  final isMedium = i % 5 == 0 && !isMajor;

                  return Container(
                    width: _tickSpacing,
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: isMajor ? 40 : (isMedium ? 25 : 15),
                      width: 2,
                      color: isMajor ? theme.colorScheme.onPrimary : theme.colorScheme.onPrimary.withOpacity(0.4),
                    ),
                  );
                },
              ),

              // Static Center Indicator
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: rulerHeight + 10,
                  width: 3,
                  color: Colors.amber, // Highlighted center
                ),
              ),

              // Floating "Current Weight" Label
              Positioned(
                left: currentViewX - 25,
                top: rulerHeight + 5,
                child: Column(
                  children: [
                    const Icon(Icons.arrow_drop_up, size: 15, color: Colors.white),
                    Text(
                      'Current: ${_format(user.weight, unit)}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}