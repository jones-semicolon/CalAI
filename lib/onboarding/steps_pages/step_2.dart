import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/user_enums.dart';
import '../../providers/user_provider.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
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

  final List<WorkoutFrequency> _workoutOptions = const [
    WorkoutFrequency.low,
    WorkoutFrequency.moderate,
    WorkoutFrequency.high,
  ];
  @override
  void initState() {
    super.initState();

    // Get saved gender from UserData
    final physicalActivity = ref.read(userProvider).goal.activityLevel;

    // Find index of option matching saved gender
    final matchIndex = _workoutOptions.indexWhere((o) => o == physicalActivity);

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
            title: context.l10n.onboardingWorkoutsPerWeekTitle,
            subtitle: context.l10n.onboardingWorkoutsPerWeekSubtitle,
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
                      children: List.generate(_workoutOptions.length, (index) {
                        final item = _buildWorkoutOption(context, _workoutOptions[index]);
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
              final selectedOption = _workoutOptions[selectedIndex!];

              // Update UserData.gender in Riverpod
              ref.read(userProvider.notifier).updateLocal(
                (s) => s.copyWith(goal: s.goal.copyWith(activityLevel: selectedOption)),
              );

              debugPrint(
                'WorkoutPerWeek: $selectedOption',
              );
            }
            widget.nextPage();
          },enabled: isEnable)
        ],
      ),
    );
  }

  OptionCard _buildWorkoutOption(
    BuildContext context,
    WorkoutFrequency frequency,
  ) {
    switch (frequency) {
      case WorkoutFrequency.low:
        return OptionCard(
          title: context.l10n.workoutRangeLowTitle,
          subtitle: context.l10n.workoutRangeLowSubtitle,
          icon: Icons.fiber_manual_record,
          value: frequency,
        );
      case WorkoutFrequency.moderate:
        return OptionCard(
          title: context.l10n.workoutRangeModerateTitle,
          subtitle: context.l10n.workoutRangeModerateSubtitle,
          icon: Icons.scatter_plot,
          value: frequency,
        );
      case WorkoutFrequency.high:
        return OptionCard(
          title: context.l10n.workoutRangeHighTitle,
          subtitle: context.l10n.workoutRangeHighSubtitle,
          icon: Icons.apps,
          value: frequency,
        );
    }
  }
}
