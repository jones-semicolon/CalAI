import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';
import '../onboarding_widgets/birthday_picker_widget.dart';

class OnboardingStep7 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep7({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep7> createState() => _OnboardingStep7State();
}

class _OnboardingStep7State extends ConsumerState<OnboardingStep7> {
  // We keep a temporary local state while the user is scrolling
  // so we don't spam the provider with every tiny scroll movement.
  late DateTime selectedBirthday;

  @override
  void initState() {
    super.initState();
    // Load the existing birthday from the provider
    selectedBirthday = ref.read(userProvider).profile.birthDate!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(
            title: 'When were you born?',
            subtitle:
                'This will be taken into account when calculating your daily nutrition goals.',
          ),

          Spacer(),

          /// 🎂 Birthday Picker
          BirthdayPickerWidget(
            initialDate: selectedBirthday,
            onChanged: (date) {
              setState(() {
                selectedBirthday = date;
              });
            },
          ),

          const Spacer(),

          // SizedBox(
          //   width: double.infinity,
          //   child: ContinueButton(
          //     enabled: true, // Birthday is never null based on your provider default
          //     onNext: () {
          //       // Finalize the selection in Riverpod
          //       ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(profile: s.profile.copyWith(birthDay: selectedBirthday)));
          //
          //       debugPrint(
          //         'Birthday: ${selectedBirthday.toIso8601String()}',
          //       );
          //
          //       widget.nextPage();
          //     },
          //   ),
          // ),
          ConfirmationButtonWidget(onConfirm: () {
            // Finalize the selection in Riverpod
            ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(profile: s.profile.copyWith(birthDate: selectedBirthday)));

            debugPrint(
              'Birthday: ${selectedBirthday.toIso8601String()}',
            );

            widget.nextPage();
          },)
        ],
      ),
    );
  }
}