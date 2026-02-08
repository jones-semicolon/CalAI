import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateAccount extends StatelessWidget {
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onSkip;

  const CreateAccount({super.key, this.onGoogleSignIn, this.onSkip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = theme.scaffoldBackgroundColor;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Google sign-in CTA
          _PillButton(
            onTap: onGoogleSignIn,
            backgroundColor: scheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.google, size: 18, color: bg),
                const SizedBox(width: 12),
                Text(
                  'Sign in with Google',
                  style: TextStyle(
                    color: bg,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Skip action
          _PillButton(
            onTap: onSkip,
            backgroundColor: bg,
            borderColor: scheme.primary,
            child: Text(
              'Skip',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable pill-style button
class _PillButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color backgroundColor;
  final Color? borderColor;

  const _PillButton({
    required this.onTap,
    required this.child,
    required this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
