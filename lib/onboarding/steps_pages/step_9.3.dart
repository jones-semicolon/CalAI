import 'package:calai/onboarding/onboarding_widgets/header.dart';
import 'package:calai/onboarding/onboarding_widgets/speed_prog_slider.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/continue_button.dart';

class ProgressSpeed extends ConsumerWidget {
  final VoidCallback nextPage;
  const ProgressSpeed({super.key, required this.nextPage});

  static const double _lbPerKg = 2.20462;

  String _goalLabel(double goal, double targetGoal) =>
      targetGoal > goal ? 'Gain' : 'Lose';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme.primary;
    final userData = ref.watch(userProvider);
    debugPrint(userData.goal.weeklyRate.toString());
    final unit = userData.body.weightUnit;
    final weeklyRate = userData.goal.weeklyRate ?? 0.8; // Fallback to 0.0 if null
    final targetWeight = userData.goal.targets.weightGoal;

    final double displaySpeed = unit == WeightUnit.kg
        ? weeklyRate
        : weeklyRate * _lbPerKg;

    final unitLabel = unit.value;

    // 3. Compare safely
    final weightLabel = _goalLabel(userData.body.currentWeight, targetWeight.toDouble());

    return SafeArea(
      child: Column(
        children: [
          const Header(title: 'How fast do you want to reach your goal?'),
          const Spacer(),

          Column(
            children: [
              Text(
                '$weightLabel weight speed per week',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme,
                ),
              ),
              const SizedBox(height: 14),

              Text(
                '${displaySpeed.toStringAsFixed(1)} $unitLabel',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: theme,
                ),
              ),
              const SizedBox(height: 12),

              // Slider with icons
              const SizedBox(height: 16),
              ProgSpeedSlider(lbPerKg: _lbPerKg),
            ],
          ),

          const Spacer(),

          ConfirmationButtonWidget(onConfirm: () => nextPage())
        ],
      ),
    );
  }
}
