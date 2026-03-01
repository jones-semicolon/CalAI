import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/height_weight.dart';

class OnboardingStep6 extends ConsumerWidget {
  final VoidCallback nextPage;
  const OnboardingStep6({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SafeArea(
      child: Column(
        children: [
          Header(
            title: context.l10n.step6HeightWeightTitle,
            subtitle: context.l10n.step6HeightWeightSubtitle,
          ),

          Expanded(child: Center(child: HeightWeightPickerWidget())),

          ConfirmationButtonWidget(onConfirm: () => nextPage())
        ],
      ),
    );
  }
}
