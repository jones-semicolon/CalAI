import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';
import '../../data/user_data.dart';

class OnboardingStep4 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep4({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep4> createState() => _OnboardingStep4State();
}

class _OnboardingStep4State extends ConsumerState<OnboardingStep4> {
  bool isEnable = false;
  int? selectedIndex;

  final List<OptionCard> options = [
    OptionCard(title: 'Yes', icon: Icons.thumb_up, value: true),
    OptionCard(title: 'No', icon: Icons.thumb_down, value: false),
  ];
  @override
  void initState() {
    super.initState();

    final hasTriedOtherCalorieApps = ref
        .read(userProvider)
        .hasTriedOtherCalorieApps;

    final matchOption = options.indexWhere(
      (i) => i.title == hasTriedOtherCalorieApps,
    );

    if (matchOption != -1) {
      isEnable = true;
      selectedIndex = matchOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.read(userProvider.notifier);
    return SafeArea(
      child: Column(
        children: [
          Header(title: 'Have you tried other calorie tracking apps?'),

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

          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: isEnable,
              onNext: () {
                if (selectedIndex != null) {
                  final data = options[selectedIndex!];

                  userData.update((s) => s.copyWith(hasTriedOtherCalorieApps: data.value));
                  debugPrint('Has tried any app: $data');
                }
                widget.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
