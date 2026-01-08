import 'package:flutter/material.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingStep9 extends StatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep9({super.key, required this.nextPage});

  @override
  State<OnboardingStep9> createState() => _OnboardingStep9State();
}

class _OnboardingStep9State extends State<OnboardingStep9> {
  bool isEnable = false;
  int? selectedIndex;

  final List<OptionCard> options = [
    OptionCard(title: 'Classic', icon: FontAwesomeIcons.drumstickBite),
    OptionCard(title: 'Pescatarian', icon: FontAwesomeIcons.fish),
    OptionCard(title: 'Vegetarian', icon: FontAwesomeIcons.carrot),
    OptionCard(title: 'Vegan', icon: FontAwesomeIcons.leaf),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(
            title: 'Do you follow a specific diet?',
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
                final selectedOption = options[selectedIndex!];
                if (selectedIndex != null) {
                  debugPrint('diet: ${selectedOption.title}');
                  if (selectedOption.subtitle != null) {
                    debugPrint('diet: ${selectedOption.subtitle}');
                  }
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
