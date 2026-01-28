import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/user_data.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/header.dart';

class Demotivated extends ConsumerStatefulWidget {
  final VoidCallback nextPage;

  const Demotivated({super.key, required this.nextPage});

  @override
  ConsumerState<Demotivated> createState() => _DemotivatedState();
}

class _DemotivatedState extends ConsumerState<Demotivated> {
  int? selectedIndex;

  final List<OptionCard> choices = const [
    OptionCard(title: 'Lack of consistency', icon: Icons.bar_chart),
    OptionCard(title: 'Unhealthy eating habits', icon: Icons.fastfood),
    OptionCard(title: 'Lack of supports', icon: Icons.group),
    OptionCard(title: 'Busy schedule', icon: Icons.calendar_month),
    OptionCard(title: 'Lack of meal inspiration', icon: Icons.food_bank),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    // ✅ if user already has saved value, auto select it
    if (selectedIndex == null && user.stoppingReachGoal.isNotEmpty) {
      final matchIndex =
      choices.indexWhere((c) => c.title == user.stoppingReachGoal);

      if (matchIndex != -1) {
        selectedIndex = matchIndex;
      }
    }

    final isEnable = selectedIndex != null;

    return SafeArea(
      child: Column(
        children: [
          const Header(title: "What's stopping you from reaching your goals?"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(choices.length, (index) {
                  final item = choices[index];

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
                          setState(() => selectedIndex = index);
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: isEnable,
              onNext: () {
                if (selectedIndex != null) {
                  final selectedOption = choices[selectedIndex!];

                  userNotifier.update((value) => value.copyWith(
                    stoppingReachGoal: selectedOption.title,
                  ));

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
