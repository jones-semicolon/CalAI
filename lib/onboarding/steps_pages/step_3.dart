import 'package:calai/widgets/confirmation_button_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../onboarding_widgets/dynamic_card.dart';
import '../onboarding_widgets/animated_option_card.dart';
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

  final List<_SourceOption> _options = const [
    _SourceOption.tikTok,
    _SourceOption.youtube,
    _SourceOption.google,
    _SourceOption.playStore,
    _SourceOption.facebook,
    _SourceOption.friendOrFamily,
    _SourceOption.tv,
    _SourceOption.instagram,
    _SourceOption.x,
    _SourceOption.other,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Header(title: context.l10n.onboardingHearAboutUsTitle),

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
                      children: List.generate(_options.length, (index) {
                        final item = _buildSourceOption(context, _options[index]);
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

          // SizedBox(
          //   width: double.infinity,
          //   child: ContinueButton(
          //     enabled: isEnable,
          //     onNext: () async {
          //       // if (selectedIndex != null) {
          //       //   final selectedOption = options[selectedIndex!].title;
          //       //   final uid = FirebaseAuth.instance.currentUser?.uid;
          //       //
          //       //   if (uid != null) {
          //       //     // âœ… DIRECT TO FIRESTORE: Save marketing data to a separate collection
          //       //     // We don't save this to the User model to keep the health data clean.
          //       //     try {
          //       //       await FirebaseFirestore.instance
          //       //           .collection('onboarding_surveys')
          //       //           .doc(uid)
          //       //           .set({
          //       //         'socialSource': selectedOption,
          //       //         'surveyStep': 3,
          //       //         'updatedAt': FieldValue.serverTimestamp(),
          //       //       }, SetOptions(merge: true));
          //       //
          //       //       debugPrint('Successfully saved social source: $selectedOption');
          //       //     } catch (e) {
          //       //       debugPrint('Error saving social source: $e');
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

  OptionCard _buildSourceOption(BuildContext context, _SourceOption option) {
    switch (option) {
      case _SourceOption.tikTok:
        return OptionCard(
          title: context.l10n.sourceTikTok,
          icon: FontAwesomeIcons.tiktok,
        );
      case _SourceOption.youtube:
        return OptionCard(
          title: context.l10n.sourceYouTube,
          icon: FontAwesomeIcons.youtube,
        );
      case _SourceOption.google:
        return OptionCard(
          title: context.l10n.sourceGoogle,
          icon: FontAwesomeIcons.google,
        );
      case _SourceOption.playStore:
        return OptionCard(
          title: context.l10n.sourcePlayStore,
          icon: FontAwesomeIcons.googlePay,
        );
      case _SourceOption.facebook:
        return OptionCard(
          title: context.l10n.sourceFacebook,
          icon: FontAwesomeIcons.facebook,
        );
      case _SourceOption.friendOrFamily:
        return OptionCard(
          title: context.l10n.sourceFriendFamily,
          icon: Icons.family_restroom,
        );
      case _SourceOption.tv:
        return OptionCard(
          title: context.l10n.sourceTv,
          icon: Icons.tv,
        );
      case _SourceOption.instagram:
        return OptionCard(
          title: context.l10n.sourceInstagram,
          icon: FontAwesomeIcons.instagram,
        );
      case _SourceOption.x:
        return OptionCard(
          title: context.l10n.sourceX,
          icon: FontAwesomeIcons.xTwitter,
        );
      case _SourceOption.other:
        return OptionCard(
          title: context.l10n.sourceOther,
          icon: Icons.dynamic_feed_outlined,
        );
    }
  }
}

enum _SourceOption {
  tikTok,
  youtube,
  google,
  playStore,
  facebook,
  friendOrFamily,
  tv,
  instagram,
  x,
  other,
}
