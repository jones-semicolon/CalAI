import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_widgets/continue_button.dart';
import '../../data/user_data.dart';
import '../onboarding_widgets/weight_picker/weight_enums.dart';
import '../onboarding_widgets/weight_picker/weight_unit_provider.dart';

class EncourageMessage extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const EncourageMessage({super.key, required this.nextPage});

  @override
  ConsumerState<EncourageMessage> createState() => _EncourageMessage();
}

class _EncourageMessage extends ConsumerState<EncourageMessage> {
  bool isEnable = true;
  String? goal;
  String? targetGoal;

  @override
  void initState() {
    super.initState();

    final user = ref.read(userProvider);
    final goalString = user.goal.toLowerCase();

    if (goalString == 'lose weight') {
      goal = 'Losing';
    } else if (goalString == 'gain weight') {
      goal = 'Gaining';
    } else {
      goal = 'Maintaining';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final unit = ref.watch(weightUnitProvider); 

    final displayWeight = unit == WeightUnit.kg
        ? user.targetWeight
        : user.targetWeight * 2.20462;

    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lbs';

    return SafeArea(
      child: Column(
        children: [
          const Spacer(),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 20, color: Colors.black),
              children: [
                TextSpan(text: '$goal '),
                const TextSpan(text: 'towards '),
                TextSpan(
                  text: '${displayWeight.toStringAsFixed(1)} $unitLabel',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ContinueButton(enabled: isEnable, onNext: widget.nextPage),
          ),
        ],
      ),
    );
  }
}
