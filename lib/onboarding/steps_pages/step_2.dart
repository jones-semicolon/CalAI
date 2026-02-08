import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';

class OnboardingStep2 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep2({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep2> createState() => _OnboardingStep2State();
}

class _OnboardingStep2State extends ConsumerState<OnboardingStep2> {
  bool isEnable = false;
  int? selectedIndex;

  final List<OptionCard> options = [
    OptionCard(
      title: '0-2',
      subtitle: 'Workouts now and then',
      icon: Icons.fiber_manual_record,
      value: WorkoutFrequency.low,
    ),
    OptionCard(
      title: '3-5',
      subtitle: 'A few workouts per week',
      icon: Icons.scatter_plot,
      value: WorkoutFrequency.moderate,
    ),
    OptionCard(title: '6+', subtitle: 'Dedicated athlete', icon: Icons.apps, value: WorkoutFrequency.high),
  ];
  @override
  void initState() {
    super.initState();

    // Get saved gender from UserData
    final physicalActivity = ref.read(userProvider).goal.activityLevel;

    // Find index of option matching saved gender
    final matchIndex = options.indexWhere((o) => o.value == physicalActivity);

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
            title: 'How many workouts do you do per week?',
            subtitle: 'This will be used to calibrate your custom plan.',
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

          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: isEnable,
              onNext: () {
                if (selectedIndex != null) {
                  final selectedOption = options[selectedIndex!];

                  // Update UserData.gender in Riverpod
                  ref.read(userProvider.notifier).updateLocal((s) => s.copyWith(goal: s.goal.copyWith(activityLevel: selectedOption.value)));

                  debugPrint(
                    'WorkoutPerWeek: ${selectedOption.value}',
                  );
                }
                // TODO : this will post to api
                widget.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
