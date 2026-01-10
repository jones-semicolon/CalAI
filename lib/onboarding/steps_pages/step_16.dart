import 'package:flutter/material.dart';
import '../onboarding_widgets/continue_button.dart';

class OnboardingStep16 extends StatelessWidget {
  final VoidCallback nextPage;
  const OnboardingStep16({super.key, required this.nextPage});

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
                      color: Theme.of(context).colorScheme.onPrimary,
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
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: ContinueButton(enabled: true, onNext: nextPage),
          ),
        ],
      ),
    );
  }
}
