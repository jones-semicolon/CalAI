import 'package:flutter/material.dart';
import '../onboarding_widgets/continue_button.dart';
import '../onboarding_widgets/header.dart';

class OnboardingStep13 extends StatefulWidget {
  final VoidCallback nextPage;
  const OnboardingStep13({super.key, required this.nextPage});

  @override
  State<OnboardingStep13> createState() => _OnboardingStep13State();
}

class _OnboardingStep13State extends State<OnboardingStep13>
    with SingleTickerProviderStateMixin {
  bool isAllowNotification = true;

  late final AnimationController _controller;
  late final Animation<Offset> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.15),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonHeight = 60.0;
    final cardPadding = 15.0;

    return SafeArea(
      child: Column(
        children: [
          Spacer(),
          const Header(
            title: 'Reach your goals with notifications',
            textAlign: TextAlign.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 10),

          /// Main content card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// Card with buttons
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: cardPadding,
                          horizontal: 40,
                        ),
                        child: Text(
                          'Cal AI would like to send you Notifications',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1.5,
                        color: Theme.of(context).shadowColor,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isAllowNotification = false),
                              child: Container(
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  color: !isAllowNotification
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                ),
                                child: Center(
                                  child: Text(
                                    "Don't Allow",
                                    style: TextStyle(
                                      color: !isAllowNotification
                                          ? Theme.of(
                                              context,
                                            ).scaffoldBackgroundColor
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isAllowNotification = true),
                              child: Container(
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: isAllowNotification
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                ),
                                child: Center(
                                  child: Text(
                                    "Allow",
                                    style: TextStyle(
                                      color: isAllowNotification
                                          ? Theme.of(
                                              context,
                                            ).scaffoldBackgroundColor
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Hand icon under Allow button
                Positioned(
                  bottom: -50,
                  left: (screenWidth / 1.5),
                  child: SlideTransition(
                    position: _bounceAnimation,
                    child: const Icon(
                      Icons.pan_tool_alt_rounded,
                      size: 40,
                      color: Color.fromARGB(255, 255, 201, 40),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          /// Continue button
          SizedBox(
            width: double.infinity,
            child: ContinueButton(
              enabled: true,
              //TODO: allow notifications
              onNext: widget.nextPage,
            ),
          ),
        ],
      ),
    );
  }
}
