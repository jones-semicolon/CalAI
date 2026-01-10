import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;
  const Header({
    super.key,
    required this.title,
    this.subtitle,
    this.textAlign = TextAlign.start,
    CrossAxisAlignment? crossAxisAlignment,
  }) : crossAxisAlignment =
           crossAxisAlignment ??
           (textAlign == TextAlign.center
               ? CrossAxisAlignment.center
               : CrossAxisAlignment.start);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          /// TITLE
          Text(
            title,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),

          /// SUBTITLE (optional)
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              textAlign: textAlign,
              subtitle!,
              style: TextStyle(fontSize: 14, color: colorScheme.onSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
