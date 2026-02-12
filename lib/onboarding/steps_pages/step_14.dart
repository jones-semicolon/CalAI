import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod
import '../../providers/user_provider.dart';           // Import your provider
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/yes_no_button.dart';

class OnboardingStep14 extends ConsumerWidget { // Changed to ConsumerStatefulWidget
  final VoidCallback nextPage;
  const OnboardingStep14({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          const Header(title: 'Add calories burned back to your daily goal?'),
          const Spacer(),
          NoYesButton(
            onNo: () {
              ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(settings: s.settings.copyWith(isAddCalorieBurn: false)));
              nextPage();
            },
            onYes: () {
              ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(settings: s.settings.copyWith(isAddCalorieBurn: true)));
              nextPage();
            },
          ),
        ],
      ),
    );
  }
}