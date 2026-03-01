import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingStep10 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep10({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep10> createState() => _OnboardingStep10State();
}

class _OnboardingStep10State extends ConsumerState<OnboardingStep10> {
  bool isEnable = false;
  int? selectedIndex;

  final List<GoalFocus> options = [
    GoalFocus.healthier,
    GoalFocus.energy,
    GoalFocus.consistency,
    GoalFocus.bodyConfidence,
  ];
  @override
  void initState() {
    super.initState();
    final accomplish = ref.read(userProvider).goal.motivation;

    final matchOption = options.indexWhere((i) => i == accomplish);
    if (matchOption != -1) {
      selectedIndex = matchOption;
      isEnable = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.read(userProvider.notifier);
    return SafeArea(
      child: Column(
        children: [
          Header(title: context.l10n.step10AccomplishTitle),

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
                      children: List.generate(options.length, (index) {
                        final item = options[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: AnimatedOptionCard(
                            index: index,
                            child: OptionCard(
                              icon: _goalFocusIcon(item),
                              title: _goalFocusTitle(context, item),
                              isSelected: selectedIndex == index,
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (!mounted) return;
                                  setState(() {
                                    isEnable = true;
                                    selectedIndex = index;
                                  });
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

          ConfirmationButtonWidget(onConfirm: () {
            if (selectedIndex != null) {
              final data = options[selectedIndex!];
              userNotifier.updateLocal(
                (s) => s.copyWith(goal: s.goal.copyWith(motivation: data)),
              );
              debugPrint('Like to accomplish: $data');
            }
            widget.nextPage();
          }, enabled: isEnable,)
        ],
      ),
    );
  }

  IconData _goalFocusIcon(GoalFocus goalFocus) {
    switch (goalFocus) {
      case GoalFocus.healthier:
        return FontAwesomeIcons.appleWhole;
      case GoalFocus.energy:
        return FontAwesomeIcons.sun;
      case GoalFocus.consistency:
        return FontAwesomeIcons.personRunning;
      case GoalFocus.bodyConfidence:
        return FontAwesomeIcons.personPraying;
    }
  }

  String _goalFocusTitle(BuildContext context, GoalFocus goalFocus) {
    switch (goalFocus) {
      case GoalFocus.healthier:
        return context.l10n.step10OptionHealthier;
      case GoalFocus.energy:
        return context.l10n.step10OptionEnergyMood;
      case GoalFocus.consistency:
        return context.l10n.step10OptionConsistency;
      case GoalFocus.bodyConfidence:
        return context.l10n.step10OptionBodyConfidence;
    }
  }
}
