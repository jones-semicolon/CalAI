import 'package:flutter/material.dart';

class PushPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  PushPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 380),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final inTween = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(
              CurveTween(
                curve: const Cubic(0.2, 0.2, 0.2, 1.0), 
              ),
            );

            final outTween = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.2, 0.0),
            ).chain(
              CurveTween(
                curve: Curves.easeOutCubic,
              ),
            );

            return Stack(
              children: [
                SlideTransition(
                  position: secondaryAnimation.drive(outTween),
                  child: Container(color: Colors.white),
                ),
                SlideTransition(
                  position: animation.drive(inTween),
                  child: child,
                ),
              ],
            );
          },
        );
}
