import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingStep1 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const OnboardingStep1({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep1> createState() => _OnboardingStep1State();
}

class _OnboardingStep1State extends ConsumerState<OnboardingStep1> {
  bool isEnable = false;
  int? selectedIndex;

  final List<Gender> _genderOptions = const [
    Gender.female,
    Gender.male,
    Gender.other,
  ];

  @override
  void initState() {
    super.initState();

    // Get saved gender from UserData
    final savedGender = ref.read(userProvider).profile.gender;

    // Find index of option matching saved gender
    final matchIndex = _genderOptions.indexWhere((o) => o == savedGender);

    if (matchIndex != -1) {
      selectedIndex = matchIndex;
      isEnable = true; // enable continue because something is already selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(
            title: context.l10n.onboardingChooseGenderTitle,
            subtitle: context.l10n.onboardingChooseGenderSubtitle,
          ),

          /// SCROLLABLE CONTENT
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_genderOptions.length, (index) {
                        final item = _buildGenderOption(context, _genderOptions[index]);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: AnimatedOptionCard(
                            index: index,
                            child: OptionCard(
                              icon: item.icon,
                              title: item.title,
                              subtitle: item.subtitle,
                              isSelected: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  isEnable = true;
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ConfirmationButtonWidget(
            onConfirm: () {
              if (selectedIndex != null) {
                final selectedGender = _genderOptions[selectedIndex!];

                ref
                    .read(userProvider.notifier)
                    .updateLocal(
                      (s) => s.copyWith(
                        profile: s.profile.copyWith(
                          gender: selectedGender,
                        ),
                      ),
                    );
                debugPrint('Gender: $selectedGender');
              }
              widget.nextPage();
            },
            enabled: isEnable,
          ),
        ],
      ),
    );
  }

  OptionCard _buildGenderOption(BuildContext context, Gender gender) {
    switch (gender) {
      case Gender.female:
        return OptionCard(title: context.l10n.genderFemale, value: gender);
      case Gender.male:
        return OptionCard(title: context.l10n.genderMale, value: gender);
      case Gender.other:
        return OptionCard(title: context.l10n.genderOther, value: gender);
    }
  }
}
