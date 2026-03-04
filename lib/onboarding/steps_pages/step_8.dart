import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/header.dart';

class OnboardingStep8 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep8({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep8> createState() => _OnboardingStep8State();
}

class _OnboardingStep8State extends ConsumerState<OnboardingStep8> {
  bool isEnable = false;
  int? selectedIndex;

  final List<Goal> options = [
    Goal.loseWeight,
    Goal.maintain,
    Goal.gainWeight,
  ];
  @override
  void initState() {
    super.initState();

    final Goal? goal = ref.read(userProvider).goal.type;

    final matchOption = options.indexWhere((i) => i == goal);
    if (matchOption != -1) {
      selectedIndex = matchOption;
      isEnable = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(
            title: context.l10n.step8GoalQuestionTitle,
            subtitle: context.l10n.step8GoalQuestionSubtitle,
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
                      children: List.generate(options.length, (index) {
                        final item = options[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: AnimatedOptionCard(
                            index: index,
                            child: OptionCard(
                              title: _goalTitle(context, item),
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
              final updateGoal = options[selectedIndex!];
              ref
                  .read(userProvider.notifier)
                  .updateLocal((s) => s.copyWith(goal: s.goal.copyWith(type: updateGoal)));
              debugPrint('Goal: $updateGoal');
            }
            widget.nextPage();
          }, enabled: isEnable,)
        ],
      ),
    );
  }

  String _goalTitle(BuildContext context, Goal goal) {
    switch (goal) {
      case Goal.loseWeight:
        return context.l10n.goalLoseWeight;
      case Goal.maintain:
        return context.l10n.goalMaintainWeight;
      case Goal.gainWeight:
        return context.l10n.goalGainWeight;
    }
  }
}
