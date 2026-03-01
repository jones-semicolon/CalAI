import 'package:flutter/material.dart';
import 'package:calai/l10n/l10n.dart';

class ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onNext;
  final String? text;

  const ContinueButton({
    super.key,
    this.enabled = true,
    required this.onNext,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 14, bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -4),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: enabled ? onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            disabledBackgroundColor: Theme.of(
              context,
            ).disabledColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            text ?? context.l10n.continueLabel,
            style: TextStyle(
              color: enabled
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).scaffoldBackgroundColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
