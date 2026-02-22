import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/loading_widget/health_plan_loading_widget.dart';

class OnboardingStep17 extends StatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep17({super.key, required this.nextPage});

  @override
  State<OnboardingStep17> createState() => _OnboardingStep17State();
}

class _OnboardingStep17State extends State<OnboardingStep17> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Spacer(),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "All done!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Time to generate your custom plan!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Continue button
          ConfirmationButtonWidget(onConfirm: widget.nextPage)
        ],
      ),
    );
  }
}



