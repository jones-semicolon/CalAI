import 'package:flutter/material.dart';

class ConfirmationButtonWidget extends StatelessWidget {
  final bool enabled;
  final VoidCallback onConfirm;
  final String text;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final Color? color;

  const ConfirmationButtonWidget({
    super.key,
    this.enabled = true,
    required this.onConfirm,
    this.text = 'Continue',
    this.padding,
    this.decoration,
    this.backgroundColor,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: padding ?? EdgeInsets.only(left: 25, right: 25, top: 14, bottom: 20),
        decoration: decoration ?? BoxDecoration(
          color: Colors.transparent,
        ),
        child: ElevatedButton(
          onPressed: enabled ? onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
            disabledBackgroundColor: Theme.of(
              context,
            ).disabledColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: enabled
                  ? (color ?? Theme.of(context).scaffoldBackgroundColor)
                  : (color ?? Theme.of(context).scaffoldBackgroundColor),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
