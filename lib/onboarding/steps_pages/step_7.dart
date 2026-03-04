import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/header.dart';
import '../../widgets/profile_widgets/birthday_picker_widget.dart';

class OnboardingStep7 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep7({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep7> createState() => _OnboardingStep7State();
}

class _OnboardingStep7State extends ConsumerState<OnboardingStep7> {
  late DateTime selectedBirthday;

  @override
  void initState() {
    super.initState();
    selectedBirthday = ref.read(userProvider).profile.birthDate!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(
            title: context.l10n.step7WhenWereYouBorn,
            subtitle: context.l10n.step6HeightWeightSubtitle,
          ),

          Spacer(),

          BirthdayPickerWidget(
            initialDate: selectedBirthday,
            onChanged: (date) {
              setState(() {
                selectedBirthday = date;
              });
            },
          ),

          const Spacer(),

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
