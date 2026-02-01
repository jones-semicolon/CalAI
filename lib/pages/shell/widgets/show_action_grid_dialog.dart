import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import '../../home/widgets/floating_action_button.dart';

/// Shows a custom dialog with a grid of floating action buttons.
///
/// This function uses [showGeneralDialog] to create a custom modal presentation
/// with a slide-up and fade-in animation for the [FloatingActionGrid].
Future<void> showActionGridDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: Colors.black26,
    transitionDuration: AppDurations.fast,
    pageBuilder: (context, anim1, anim2) {
      // The pageBuilder can return a minimal widget because the
      // transitionBuilder is responsible for the actual dialog content.
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Use a CurvedAnimation for a smoother, non-linear transition.
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );

      // Combine Opacity and Transform to create the slide and fade effect.
      return Opacity(
        opacity: curvedAnimation.value,
        child: Transform.translate(
          // Animate the vertical offset from 50 (off-screen) to 0 (in position).
          offset: Offset(0, 50 * (1 - curvedAnimation.value)),
          child: const FloatingActionGrid(),
        ),
      );
    },
  );
}
