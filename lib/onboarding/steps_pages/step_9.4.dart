import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../onboarding_widgets/calai_comparison.dart';
import '../onboarding_widgets/header.dart';

class Comparison extends StatelessWidget {
  final VoidCallback nextPage;
  const Comparison({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(title: context.l10n.step94ComparisonTitle),
          Spacer(),
          ComparisonCard(),
          Spacer(),
          
          ConfirmationButtonWidget(onConfirm: () => nextPage())
        ],
      ),
    );
  }
}
