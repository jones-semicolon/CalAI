import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/height_weight.dart';

class OnboardingStep6 extends ConsumerWidget {
  final VoidCallback nextPage;
  const OnboardingStep6({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return SafeArea(
      child: Column(
        children: [
          const Header(
            title: 'Height & Weight',
            subtitle:
                'This will be taken into account when calculating your daily nutrition goals.',
          ),

          Expanded(child: Center(child: HeightWeightPickerWidget())),
          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: true,
              onNext: () {
                print(
                  'Height: ${user.body.height}, Weight: ${user.body.currentWeight}',
                ); // actual provider values
                nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
