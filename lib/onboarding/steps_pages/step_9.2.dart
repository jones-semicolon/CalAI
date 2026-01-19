import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding_widgets/continue_button.dart';
import '../../data/user_data.dart';
import '../onboarding_widgets/weight_picker/weight_enums.dart';
import '../onboarding_widgets/weight_picker/weight_unit_provider.dart';

class EncourageMessage extends ConsumerWidget {
  final VoidCallback nextPage;
  const EncourageMessage({super.key, required this.nextPage});

  static const double _lbPerKg = 2.20462;

  String _goalLabel(double goal, double targetGoal) {
    if (targetGoal > goal) {
      return 'Gaining';
    } else {
      return 'Losing';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.onPrimary;

    final user = ref.watch(userProvider);
    final unit = ref.watch(weightUnitProvider);

    final goalText = _goalLabel(user.weight, user.targetWeight);

    final double weightDiff = unit == WeightUnit.kg
        ? (user.targetWeight - user.weight).abs()
        : ((user.targetWeight - user.weight) * _lbPerKg).abs();

    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lbs';

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: primary,
                    ),
                    children: [
                      TextSpan(text: '$goalText '),
                      TextSpan(
                        text: '${weightDiff.toStringAsFixed(1)} $unitLabel',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 222, 154, 105),
                        ),
                      ),
                      const TextSpan(
                        text: ' is a realistic target. It’s not hard at all!',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  '90% of users say the change is obvious after using Cal AI, and it’s not easy to rebound.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primary, fontSize: 16),
                ),
              ],
            ),
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
