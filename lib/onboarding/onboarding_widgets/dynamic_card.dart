import 'package:flutter/material.dart';
import 'package:calai/l10n/app_strings.dart';

class OptionCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSelected;

  const OptionCard({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSelected = false,
  });

  bool get _isTextOnly => icon == null && subtitle == null;

  @override
  Widget build(BuildContext context) {
    final cardColor = isSelected
        ? Theme.of(context)
              .colorScheme
              .onPrimary // selected background
        : Theme.of(context).colorScheme.secondary; // default

    final borderColor = isSelected
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).dividerColor;

    final textColor = isSelected
        ? Theme.of(context)
              .scaffoldBackgroundColor // text when selected
        : Theme.of(context).colorScheme.onPrimary;

    final subtitleColor = isSelected
        ? Theme.of(context).scaffoldBackgroundColor
        : Theme.of(context).colorScheme.onSecondary;

    final iconColor = Theme.of(context).scaffoldBackgroundColor;

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
                          color: Theme.of(context).colorScheme.onPrimary,
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
                            context.tr(title),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (subtitle != null) ...[
                            Text(
                              context.tr(subtitle!),
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
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
