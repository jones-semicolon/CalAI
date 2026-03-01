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

class OnboardingStep9 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep9({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep9> createState() => _OnboardingStep9State();
}

class _OnboardingStep9State extends ConsumerState<OnboardingStep9> {
  bool isEnable = false;
  int? selectedIndex;

  final List<DietType> options = [
    DietType.classic,
    DietType.pescatarian,
    DietType.vegetarian,
    DietType.vegan,
  ];
  @override
  void initState() {
    super.initState();
    final dietType = ref.read(userProvider).goal.dietType;

    final matchOption = options.indexWhere((i) => i == dietType);
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
          Header(title: context.l10n.step9SpecificDietQuestion),

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
                              icon: _dietIcon(item),
                              title: _dietTitle(context, item),
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
                (s) => s.copyWith(goal: s.goal.copyWith(dietType: data)),
              );
            }
            widget.nextPage();
          }, enabled: isEnable,)
        ],
      ),
    );
  }

  IconData _dietIcon(DietType dietType) {
    switch (dietType) {
      case DietType.classic:
        return FontAwesomeIcons.drumstickBite;
      case DietType.pescatarian:
        return FontAwesomeIcons.fish;
      case DietType.vegetarian:
        return FontAwesomeIcons.carrot;
      case DietType.vegan:
        return FontAwesomeIcons.leaf;
    }
  }

  String _dietTitle(BuildContext context, DietType dietType) {
    switch (dietType) {
      case DietType.classic:
        return context.l10n.step9DietClassic;
      case DietType.pescatarian:
        return context.l10n.step9DietPescatarian;
      case DietType.vegetarian:
        return context.l10n.step9DietVegetarian;
      case DietType.vegan:
        return context.l10n.step9DietVegan;
    }
  }
}
