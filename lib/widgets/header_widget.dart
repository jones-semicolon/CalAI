import 'package:flutter/material.dart';
import 'package:calai/widgets/circle_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final VoidCallback? onBackTap;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity, // ✅ Force full width
        height: preferredSize.height,
        // ✅ Remove internal padding that was shrinking the stack
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Center Title
            // Wrap in Padding only to prevent text from hitting buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56.0),
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ) ??
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                child: title,
              ),
            ),

            // 2. Back Button (Left)
            Positioned(
              left: 16, // ✅ Use left positioning instead of padding
              child: CircleBackButton(
                onTap: onBackTap ?? () => Navigator.pop(context),
              ),
            ),

            // 3. Actions (Right)
            if (actions != null)
              Positioned(
                right: 16, // ✅ Use right positioning
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}