import 'package:flutter/material.dart';

import 'gradient_progress_line.dart';
import 'checklist_card.dart';

class HealthPlanLoadingWidget extends StatefulWidget {
  final VoidCallback? onFinished;

  const HealthPlanLoadingWidget({super.key, this.onFinished});

  @override
  State<HealthPlanLoadingWidget> createState() =>
      _HealthPlanLoadingWidgetState();
}

class _HealthPlanLoadingWidgetState extends State<HealthPlanLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _controller.forward().whenComplete(() async {
      widget.onFinished?.call();

      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get percentage {
    final t = _controller.value;
    double curved;

    if (t <= 0.25) {
      curved = Curves.easeInOut.transform(t / 0.25) * 0.25;
    } else if (t <= 0.50) {
      curved = 0.25 + Curves.easeInOut.transform((t - 0.25) / 0.25) * 0.25;
    } else if (t <= 0.75) {
      curved = 0.50 + Curves.easeInOut.transform((t - 0.50) / 0.25) * 0.25;
    } else {
      curved = 0.75 + Curves.easeInOut.transform((t - 0.75) / 0.25) * 0.25;
    }

    return (curved * 99).round();
  }

  double get lineProgress => percentage / 100;

  String get statusLabel {
    final p = percentage;
    if (p <= 24) return "Customizing health plan...";
    if (p <= 49) return "Applying BMR formula...";
    if (p <= 74) return "Estimating your metabolic age...";
    return "Finalizing results...";
  }

  bool isChecked(String key) {
    final p = percentage;
    switch (key) {
      case 'calories':
        return p >= 0;
      case 'carbs':
        return p >= 25;
      case 'protein':
      case 'fats':
        return p >= 50;
      case 'health':
        return p >= 75;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$percentage%",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  "We're setting everything\nup for you",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 24),

                GradientProgressLine(value: lineProgress),

                const SizedBox(height: 20),

                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 32),

                ChecklistCard(
                  calories: isChecked('calories'),
                  carbs: isChecked('carbs'),
                  protein: isChecked('protein'),
                  fats: isChecked('fats'),
                  health: isChecked('health'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
