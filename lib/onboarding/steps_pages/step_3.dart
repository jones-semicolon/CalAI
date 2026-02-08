import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';

class OnboardingStep3 extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep3({super.key, required this.nextPage});

  @override
  ConsumerState<OnboardingStep3> createState() => _OnboardingStep3State();
}

class _OnboardingStep3State extends ConsumerState<OnboardingStep3> {
  bool isEnable = false;
  int? selectedIndex;

  final List<OptionCard> options = [
    OptionCard(title: 'Tik Tok', icon: FontAwesomeIcons.tiktok),
    OptionCard(title: 'YouTube', icon: FontAwesomeIcons.youtube),
    OptionCard(title: 'Google', icon: FontAwesomeIcons.google),
    OptionCard(title: 'Play Store', icon: FontAwesomeIcons.googlePay),
    OptionCard(title: 'Facebook', icon: FontAwesomeIcons.facebook),
    OptionCard(title: 'Friend or family', icon: Icons.family_restroom),
    OptionCard(title: 'TV', icon: Icons.tv),
    OptionCard(title: 'Instagram', icon: FontAwesomeIcons.instagram),
    OptionCard(title: 'X', icon: FontAwesomeIcons.xTwitter),
    OptionCard(title: 'Other', icon: Icons.dynamic_feed_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(title: 'Where did you hear about us?'),

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
              onNext: () async {
                if (selectedIndex != null) {
                  final selectedOption = options[selectedIndex!].title;
                  final uid = FirebaseAuth.instance.currentUser?.uid;

                  if (uid != null) {
                    // ✅ DIRECT TO FIRESTORE: Save marketing data to a separate collection
                    // We don't save this to the User model to keep the health data clean.
                    try {
                      await FirebaseFirestore.instance
                          .collection('onboarding_surveys')
                          .doc(uid)
                          .set({
                        'socialSource': selectedOption,
                        'surveyStep': 3,
                        'updatedAt': FieldValue.serverTimestamp(),
                      }, SetOptions(merge: true));

                      debugPrint('Successfully saved social source: $selectedOption');
                    } catch (e) {
                      debugPrint('Error saving social source: $e');
                    }
                  }
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
