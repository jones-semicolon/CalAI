import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';

import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/loading_widget/health_plan_loading_widget.dart';

class OnboardingStep17 extends StatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep17({super.key, required this.nextPage});

  @override
  State<OnboardingStep17> createState() => _OnboardingStep17State();
}

class _OnboardingStep17State extends State<OnboardingStep17> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.tr("All done!"),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  context.tr("Time to generate your custom plan!"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: !_isLoading,
              onNext: _startCalibration,
            ),
          ),
        ],
      ),
    );
  }

  /// SHOW LOADING
  void _startCalibration() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      pageBuilder: (_, __, ___) {
        return HealthPlanLoadingWidget(
          onFinished: () {
            if (!mounted) return;

            Navigator.of(context).pop();
            widget.nextPage();
          },
        );
      },
    );
  }
}
