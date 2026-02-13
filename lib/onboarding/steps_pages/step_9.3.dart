import 'package:calai/onboarding/onboarding_widgets/header.dart';
import 'package:calai/onboarding/onboarding_widgets/speed_prog_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calai/l10n/app_strings.dart';
import '../onboarding_widgets/continue_button.dart';
import '../../data/user_data.dart';
import '../onboarding_widgets/weight_picker/weight_enums.dart';
import '../onboarding_widgets/weight_picker/weight_unit_provider.dart';

enum SpeedLevel { slow, recommended, aggressive }

class ProgressSpeed extends ConsumerWidget {
  final VoidCallback nextPage;
  const ProgressSpeed({super.key, required this.nextPage});

  static const double _lbPerKg = 2.20462;

  String _goalLabel(double goal, double targetGoal) =>
      targetGoal > goal ? 'Gain' : 'Lose';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme.onPrimary;
    final unit = ref.watch(weightUnitProvider);
    final userData = ref.watch(userProvider);

    // Display speed in selected unit
    final double displaySpeed = unit == WeightUnit.kg
        ? userData.progressSpeed
        : userData.progressSpeed * _lbPerKg;
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lbs';
    final weightLabel = _goalLabel(userData.weight, userData.targetWeight);

    return SafeArea(
      child: Column(
        children: [
          const Header(title: 'How fast do you want to reach your goal?'),
          const Spacer(),

          Column(
            children: [
              Text(
                '${context.tr(weightLabel)} ${context.tr('weight speed per week')}',
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
          SizedBox(
            width: double.infinity,
            child: ContinueButton(enabled: true, onNext: nextPage),
          ),
        ],
      ),
    );
  }
}
