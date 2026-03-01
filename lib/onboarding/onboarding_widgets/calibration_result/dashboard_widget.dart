import 'package:calai/l10n/l10n.dart';
import 'package:calai/onboarding/onboarding_widgets/calibration_result/hyper_link_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../enums/user_enums.dart';
import '../../../providers/user_provider.dart';
import 'app_constants.dart';
import 'health_score_card.dart';
import 'macro_card.dart';

class MacroData {
  final String title;
  final String value;
  final double progress;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const MacroData({
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
    required this.icon,
    this.onTap,
  });
}

class _ReachGoal extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _ReachGoal({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(AppRadius.badge),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xLarge,
          vertical: AppSpacing.xLarge,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: AppSpacing.xLarge),
            Expanded(
              child: Text(
                title,
                softWrap: true,
                maxLines: null,
                overflow: TextOverflow.visible,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.primary(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyRecommendationDashboard extends ConsumerStatefulWidget {
  final List<MacroData> macros;
  final double healthScoreProgress;
  final int healthScore;
  final int healthScoreMax;
  final VoidCallback? onHealthScoreTap;

  const DailyRecommendationDashboard({
    super.key,
    required this.macros,
    required this.healthScoreProgress,
    required this.healthScore,
    this.healthScoreMax = 10,
    this.onHealthScoreTap,
  }) : assert(macros.length == 4);

  static const double _desktopBreakpoint = 900;

  @override
  ConsumerState<DailyRecommendationDashboard> createState() =>
      _DailyRecommendationDashboardState();
}

class _DailyRecommendationDashboardState
    extends ConsumerState<DailyRecommendationDashboard> {
  @override
  Widget build(BuildContext context) {
    final weightGoal = ref.watch(userProvider).goal.type;
    final unit = ref.watch(userProvider).body.weightUnit;
    final user = ref.watch(userProvider);
    final unitLabel = unit.value;
    final l10n = context.l10n;

    final DateTime today = DateTime.now();
    final DateTime datePlus30 = today.add(const Duration(days: 30));
    final String localeTag = Localizations.localeOf(context).toLanguageTag();
    final String formattedDate = DateFormat('dd MMMM', localeTag).format(
      datePlus30,
    );

    double weightDiff;
    if (weightGoal != Goal.maintain) {
      final double diffKg =
          (user.goal.targets.weightGoal - user.body.currentWeight).abs();
      weightDiff = unit == WeightUnit.kg ? diffKg : diffKg * 2.20462;
    } else {
      weightDiff = unit == WeightUnit.kg
          ? user.body.currentWeight
          : user.body.currentWeight * 2.20462;
    }

    String recommendationAction;
    switch (weightGoal) {
      case Goal.gainWeight:
        recommendationAction = l10n.dashboardShouldGainWeight;
        break;
      case Goal.loseWeight:
        recommendationAction = l10n.dashboardShouldLoseWeight;
        break;
      case Goal.maintain:
      default:
        recommendationAction = l10n.dashboardShouldMaintainWeight;
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLarge =
            constraints.maxWidth >=
            DailyRecommendationDashboard._desktopBreakpoint;
        final int crossAxisCount = isLarge ? 4 : 2;

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 48,
                      color: AppColors.primary(context),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      l10n.dashboardCongratsPlanReady,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.value.copyWith(
                        color: AppColors.primary(context),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    Text(
                      l10n.dashboardYouShouldGoal(recommendationAction),
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.primary(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.small,
                        vertical: AppSpacing.xxSmall,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onTertiary,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                      child: Text(
                        l10n.dashboardWeightGoalByDate(
                          weightDiff.toStringAsFixed(1),
                          unitLabel,
                          formattedDate,
                        ),
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.primary(context),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onTertiary,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dashboardDailyRecommendation,
                        style: AppTextStyles.headTitle.copyWith(
                          color: Theme.of(context).colorScheme.primary
                              .withOpacity(0.8),
                        ),
                      ),
                      Text(
                        l10n.dashboardEditAnytime,
                        style: AppTextStyles.title.copyWith(
                          color: Theme.of(context).colorScheme.primary
                              .withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.large),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.macros.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: AppSpacing.medium,
                          mainAxisSpacing: AppSpacing.medium,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final macro = widget.macros[index];
                          return MacroCard(
                            title: macro.title,
                            value: macro.value,
                            progress: macro.progress,
                            progressColor: macro.color,
                            icon: macro.icon,
                            onTap: macro.onTap,
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.large),
                      HealthScoreCard(
                        progress: widget.healthScoreProgress,
                        score: widget.healthScore,
                        maxScore: widget.healthScoreMax,
                        onTap: widget.onHealthScoreTap,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xLarge),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.large),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dashboardHowToReachGoals,
                      style: AppTextStyles.headTitle.copyWith(
                        color: AppColors.primary(context),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _ReachGoal(
                      title: l10n.dashboardReachGoalLifeScore,
                      icon: Icons.heart_broken,
                      color: AppColors.heartIcon,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _ReachGoal(
                      title: l10n.dashboardReachGoalTrackFood,
                      icon: Icons.restaurant_menu,
                      color: AppColors.healthBarActive,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _ReachGoal(
                      title: l10n.dashboardReachGoalFollowCalories,
                      icon: Icons.local_fire_department,
                      color: AppColors.primary(context),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _ReachGoal(
                      title: l10n.dashboardReachGoalBalanceMacros,
                      icon: Icons.pie_chart,
                      color: AppColors.carbs,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xLarge),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.large),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dashboardPlanSourcesTitle,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.primary(context),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    HyperlinkText(
                      text: l10n.dashboardSourceBasalMetabolicRate,
                      url:
                          'https://www.healthline.com/health/what-is-basal-metabolic-rate',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    HyperlinkText(
                      text: l10n.dashboardSourceCalorieCountingHarvard,
                      url:
                          'https://www.health.harvard.edu/staying-healthy/calorie-counting-made-easy',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    HyperlinkText(
                      text: l10n.dashboardSourceInternationalSportsNutrition,
                      url: 'https://pubmed.ncbi.nlm.nih.gov/28630601/',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    HyperlinkText(
                      text: l10n.dashboardSourceNationalInstitutesHealth,
                      url:
                          'https://www.nhlbi.nih.gov/files/docs/guidelines/ob_gdlns.pdf',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
