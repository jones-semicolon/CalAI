import 'package:calai/data/health_data.dart';
import 'package:calai/data/user_data.dart';
import 'package:calai/onboarding/onboarding_widgets/calibration_result/hyper_link_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_constants.dart';
import 'macro_card.dart';
import 'health_score_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        border: Border.all(color: AppColors.border(context), width: 1.5),
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
                  color: AppColors.onPrimary(context),
                  fontWeight: FontWeight.w600,
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
    final weightGoal = ref.watch(userProvider);
    final unit = ref.watch(healthDataProvider).weightUnit;
    final user = ref.watch(userProvider);
    final unitLabel = unit.value;

    final DateTime today = DateTime.now();
    final DateTime datePlus30 = today.add(const Duration(days: 30));

    final String formattedDate = DateFormat('dd MMMM').format(datePlus30);
    double weightDiff;

    if (weightGoal.goal != Goal.maintain) {
      final double diffKg = (user.targetWeight - user.weight).abs();

      weightDiff = unit == WeightUnit.kg ? diffKg : diffKg * 2.20462;
    } else {
      weightDiff = unit == WeightUnit.kg ? user.weight : user.weight * 2.20462;
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
                      color: AppColors.onPrimary(context),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      textAlign: TextAlign.center,
                      "Congratulations\n your custom plan is ready!",
                      style: AppTextStyles.value.copyWith(
                        color: AppColors.onPrimary(context),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    Text(
                      'You should ${weightGoal.goal.value.split(' ')[0]}:',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.onPrimary(context),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xSmall,
                        vertical: AppSpacing.xxxSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.circularBg(context),
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                      child: Text(
                        '${weightDiff.toStringAsFixed(1)} $unitLabel by $formattedDate',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.onPrimary(context),
                          fontWeight: FontWeight.w900,
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
                    color: AppColors.circularBg(context),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    boxShadow: AppShadows.neumorphic,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ───────────── Title ─────────────
                      Text(
                        "Daily Recommendation",
                        style: AppTextStyles.headTitle.copyWith(
                          color: AppColors.value(context),
                        ),
                      ),
                      Text(
                        "You can edit this any time",
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.value(context),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.large),

                      // ───────────── Macro Grid ─────────────
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

                      // ───────────── Health Score ─────────────
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
                  color: AppColors.circularBg(context),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: AppShadows.neumorphic,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How to reach your goals:",
                      style: AppTextStyles.headTitle.copyWith(
                        color: AppColors.onPrimary(context),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _ReachGoal(
                      title:
                          'Get your weekly life score and improve your routine.',
                      icon: Icons.heart_broken,
                      color: AppColors.heartIcon,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _ReachGoal(
                      title: 'Track your food',
                      icon: Icons.restaurant_menu,
                      color: AppColors.healthBarActive,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _ReachGoal(
                      title: 'Follow your daily calorie recommendation',
                      icon: Icons.local_fire_department,
                      color: AppColors.onPrimary(context),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    _ReachGoal(
                      title: 'Balance your carbs, protein, fat',
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
                  color: AppColors.circularBg(context),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: AppShadows.neumorphic,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Plan base on the following sources, among other peer-reviewed medical studies:",
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.onPrimary(context),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    HyperlinkText(
                      text: '• Basal metabolic rate',
                      url:
                          'https://www.healthline.com/health/what-is-basal-metabolic-rate',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    HyperlinkText(
                      text: '• Calorie counting - Harvard',
                      url:
                          'https://www.health.harvard.edu/staying-healthy/calorie-counting-made-easy',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    HyperlinkText(
                      text: '• International Society of Sports Nutrition',
                      url: 'https://pubmed.ncbi.nlm.nih.gov/28630601/',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    HyperlinkText(
                      text: '• National Institutes of Health',
                      url: 'https://www.nhlbi.nih.gov/files/docs/guidelines/ob_gdlns.pdf',
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
