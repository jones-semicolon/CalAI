import 'package:calai/l10n/l10n.dart';
import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/header.dart';

class OnboardingStep4 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep4({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep4> createState() => _OnboardingStep4State();
}

class _OnboardingStep4State extends ConsumerState<OnboardingStep4> {
  bool isEnable = false;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final options = <OptionCard>[
      OptionCard(
        title: context.l10n.yesLabel,
        icon: Icons.thumb_up,
        value: true,
      ),
      OptionCard(
        title: context.l10n.noLabel,
        icon: Icons.thumb_down,
        value: false,
      ),
    ];

    return SafeArea(
      child: Column(
        children: [
          Header(title: context.l10n.step4TriedOtherCalorieApps),

          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                              isSelected: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  isEnable = true;
                                  selectedIndex = index;
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

          // SizedBox(
          //   width: double.infinity,
          //   child: ContinueButton(
          //     enabled: isEnable,
          //     onNext: () async {
          //       // if (selectedIndex != null) {
          //       //   final bool hasTried = options[selectedIndex!].value as bool;
          //       //   final uid = FirebaseAuth.instance.currentUser?.uid;
          //       //
          //       //   if (uid != null) {
          //       //     // ✅ DIRECT TO FIRESTORE: Keep marketing data separate
          //       //     try {
          //       //       await FirebaseFirestore.instance
          //       //           .collection('onboarding_surveys')
          //       //           .doc(uid)
          //       //           .set({
          //       //         'hasTriedOtherApps': hasTried,
          //       //         'surveyStep': 4,
          //       //         'updatedAt': FieldValue.serverTimestamp(),
          //       //       }, SetOptions(merge: true));
          //       //
          //       //       debugPrint('Survey Saved: Has tried apps = $hasTried');
          //       //     } catch (e) {
          //       //       debugPrint('Error saving survey step 4: $e');
          //       //     }
          //       //   }
          //       // }
          //       widget.nextPage();
          //     },
          //   ),
          // ),
          ConfirmationButtonWidget(onConfirm: widget.nextPage, enabled: isEnable,)
        ],
      ),
    );
  }
}
