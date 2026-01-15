import 'package:flutter/material.dart';

class OptionCard<T> extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSelected;
  final T? value;

  const OptionCard({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSelected = false,
    this.value,
  });

  bool get _isTextOnly => icon == null && subtitle == null;

  @override
  Widget build(BuildContext context) {
    final cardColor = isSelected
        ? Theme.of(context)
              .colorScheme
              .primary // selected background
        : Theme.of(context).colorScheme.onTertiary; // default

    final borderColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).splashColor;

    final textColor = isSelected
        ? Theme.of(context)
              .scaffoldBackgroundColor // text when selected
        : Theme.of(context).colorScheme.primary;

    final subtitleColor = isSelected
        ? Theme.of(context).scaffoldBackgroundColor
        : Theme.of(context).colorScheme.secondary;

    final iconColor = Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: _isTextOnly
              ? Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSecondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor),
                      ),
                      const SizedBox(width: 20),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (subtitle != null) ...[
                            Text(
                              subtitle!,
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
