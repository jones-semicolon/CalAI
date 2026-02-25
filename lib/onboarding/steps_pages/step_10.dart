import 'package:calai/widgets/confirmation_button_widget.dart';
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

  final List<OptionCard> options = [
    OptionCard(
      title: 'Eat and live healthier',
      icon: FontAwesomeIcons.appleWhole,
      value: GoalFocus.healthier,
    ),
    OptionCard(title: 'Boost my energy and mood', icon: FontAwesomeIcons.sun, value: GoalFocus.energy),
    OptionCard(
      title: 'Stay motivated and consistent',
      icon: FontAwesomeIcons.personRunning,
      value: GoalFocus.consistency,
    ),
    OptionCard(
      title: 'feel better about my body',
      icon: FontAwesomeIcons.personPraying,
      value: GoalFocus.bodyConfidence,
    ),
  ];
  @override
  void initState() {
    super.initState();
    final accomplish = ref.read(userProvider).goal.motivation;

    final matchOption = options.indexWhere((i) => i.value == accomplish);
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
          Header(title: 'What would you like to accomplish?'),

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
              final data = options[selectedIndex!];
              userNotifier.updateLocal((s) => s.copyWith(goal: s.goal.copyWith(motivation: data.value)));
              debugPrint('Like to accomplish: $data');
            }
            widget.nextPage();
          }, enabled: isEnable,)
        ],
      ),
    );
  }
}
