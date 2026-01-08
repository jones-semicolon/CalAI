import 'package:flutter/material.dart';

class OnboardingAppBar extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback? onBack;

  const OnboardingAppBar({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    this.onBack,
  });

  double get progressPercent {
    if (totalPages == 0) return 0;
    return ((currentIndex + 1) / totalPages) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogTheme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// PROGRESS BAR
            Expanded(
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  child: LinearProgressIndicator(
                    value: (progressPercent / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
