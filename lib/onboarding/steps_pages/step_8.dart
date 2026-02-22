import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/continue_button.dart';
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

  final List<OptionCard> options = [
    OptionCard(title: 'Lose Weight', value: Goal.loseWeight),
    OptionCard(title: 'Maintain', value: Goal.maintain),
    OptionCard(title: 'Gain Weight', value: Goal.gainWeight),
  ];
  @override
  void initState() {
    super.initState();

    final Goal? goal = ref.read(userProvider).goal.type;

    final matchOption = options.indexWhere((i) => i.value == goal);
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
            title: 'What is your goal?',
            subtitle: 'This helps us generate a plan for your calorie intake.',
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
                              icon: item.icon,
                              title: item.title,
                              subtitle: item.subtitle,
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
              ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(goal: s.goal.copyWith(type: updateGoal.value)));
              debugPrint('Goal: $updateGoal');
            }
            widget.nextPage();
          }, enabled: isEnable,)
        ],
      ),
    );
  }
}
