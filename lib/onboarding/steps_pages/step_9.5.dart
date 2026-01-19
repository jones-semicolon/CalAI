import 'package:flutter/material.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/user_data.dart';

class Demotivated extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const Demotivated({super.key, required this.nextPage});

  @override
  ConsumerState<Demotivated> createState() => _DemotivatedState();
}

class _DemotivatedState extends ConsumerState<Demotivated> {
  bool isEnable = false;
  int? selectedIndex;

  final List<OptionCard> options = [
    OptionCard(title: 'Lack  of consistency', icon: Icons.bar_chart),
    OptionCard(title: 'Unhealthy eating habits', icon: Icons.fastfood),
    OptionCard(title: 'Lack of supports', icon: Icons.group),
    OptionCard(title: 'Busy schedule', icon: Icons.calendar_month),
    OptionCard(title: 'Lack of meal inspiration', icon: Icons.food_bank),
  ];

  @override
  void initState() {
    super.initState();

    // Get saved gender from UserData
    final savedGender = ref.read(userProvider).stoppingReachGoal;

    // Find index of option matching saved gender
    final matchIndex = options.indexWhere((o) => o.title == savedGender);

    if (matchIndex != -1) {
      selectedIndex = matchIndex;
      isEnable = true; // enable continue because something is already selected
    }
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.read(userProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          Header(title: "What's stopping you from reaching your goals?"),

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

          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: isEnable,
              onNext: () {
                if (selectedIndex != null) {
                  final selectedOption = options[selectedIndex!];

                  // Update UserData.gender in Riverpod
                  userNotifier.setStoppingReachGoal(selectedOption.title);

                  debugPrint('stoppingReachGoal: ${selectedOption.title}');
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
