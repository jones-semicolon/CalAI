import 'package:calai/enums/user_enums.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:calai/pages/progress/screens/weight_picker_view.dart';
import 'package:flutter/material.dart';
import 'package:calai/core/constants/constants.dart';
import 'card_decorations.dart';

/// A card widget to display the user's current weight, goal, and progress.
///
/// Includes a tappable "Log Weight" button at the bottom.
class WeightCard extends StatelessWidget {
  final double currentWeight;
  final double goalWeight;
  final double progressPercent;
  final MeasurementUnit? unitSystem;

  const WeightCard({
    super.key,
    required this.currentWeight,
    required this.goalWeight,
    required this.progressPercent,
    this.unitSystem
  });

  /// Formats a double value into a string with ' kg' appended.
  String _formatKg(double v) => '${unitSystem?.metricToDisplay(v).toStringAsFixed(1) ?? v.toStringAsFixed(1)} ${unitSystem?.weightLabel ?? MeasurementUnit.metric.weightLabel}';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const WeightPickerView()));
      },
      child: Container(
        decoration: progressCardDecoration(context),
        child: Column(
          children: [
            _WeightInfo(
              currentWeight: currentWeight,
              goalWeight: goalWeight,
              progressPercent: progressPercent,
              formatKg: _formatKg,
            ),
            const _LogWeightButton(),
          ],
        ),
      ),
    );
  }
}

/// Private widget to display the core weight information and progress bar.
class _WeightInfo extends StatelessWidget {
  final double currentWeight;
  final double goalWeight;
  final double progressPercent;
  final String Function(double) formatKg;

  const _WeightInfo({
    required this.currentWeight,
    required this.goalWeight,
    required this.progressPercent,
    required this.formatKg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        children: [
          Text(
            context.l10n.myWeightTitle,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatKg(currentWeight),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.splashColor,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: (progressPercent / 100).clamp(0.0, 1.0)),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.transparent,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                goalWeight > 0
                    ? context.l10n.goalWithValue(formatKg(goalWeight))
                    : context.l10n.noGoalSet,
                style: TextStyle(fontSize: 12, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

/// Private widget for the "Log Weight" button at the bottom of the card.
class _LogWeightButton extends StatelessWidget {
  const _LogWeightButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.logWeightCta,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.scaffoldBackgroundColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: theme.scaffoldBackgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
