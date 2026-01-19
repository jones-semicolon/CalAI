import 'package:flutter/material.dart';
import '../onboarding_widgets/calai_comparison.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';

class Comparison extends StatelessWidget {
  final VoidCallback nextPage;
  const Comparison({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(title: 'Lose twice as much weight with Cal AI vs on your own'),
          Spacer(),
          ComparisonCard(),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: true,
              onNext: () {
                nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
