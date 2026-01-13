import 'package:calai/onboarding/onboarding_widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/weight_picker/weight_selection_view.dart';
import '../../data/user_data.dart';

class WeightPickerPage extends ConsumerWidget {
  final VoidCallback nextPage;

  const WeightPickerPage({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetWeight = ref.watch(userProvider);
    return SafeArea(
      child: Column(
        children: [
          const Header(title: 'What is your desired weight?'),

          const Spacer(),

          const WeightSelectionView(),

          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: true,
              onNext: () {
                debugPrint('${targetWeight.targetWeight}');
                nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
