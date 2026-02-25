import 'package:flutter/material.dart';
import '../../widgets/confirmation_button_widget.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/weight_charts.dart';

class OnboardingStep5 extends StatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep5({super.key, required this.nextPage});

  @override
  State<OnboardingStep5> createState() => _OnboardingStep5State();
}

class _OnboardingStep5State extends State<OnboardingStep5> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(title: 'Cal AI creates long-term results'),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.6,
                        child: AnimatedWeightChart(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ConfirmationButtonWidget(onConfirm: widget.nextPage)
        ],
      ),
    );
  }
}
