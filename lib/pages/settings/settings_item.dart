import 'package:flutter/material.dart';

class SettingsItemTile extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // Properties
  // ---------------------------------------------------------------------------

  final IconData? icon;
  final String label;
  final String description;

  final VoidCallback? onTap;

  /// Optional trailing widget (e.g. Switch, Icon, etc.)
  final Widget? widget;

  /// Reserved for switch-like usage
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final EdgeInsets padding;

  const SettingsItemTile({
    super.key,
    this.icon,
    required this.label,
    this.description = "",
    this.onTap,
    this.widget,
    this.value,
    this.onChanged,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  });

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            // Icon
            if (icon != null) Icon(icon, size: 20, color: color),

            if (icon != null) const SizedBox(width: 10),

            // Label & description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),

                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: TextStyle(fontSize: 10, color: color),
                    ),
                ],
              ),
            ),

            // const Spacer(),

            // Trailing widget
            widget ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
