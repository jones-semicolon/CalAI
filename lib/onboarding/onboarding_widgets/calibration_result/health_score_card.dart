import 'package:flutter/material.dart';
import 'app_constants.dart';

class HealthScoreCard extends StatelessWidget {
  final double progress;
  final int score;
  final int maxScore;
  final VoidCallback? onTap;

  const HealthScoreCard({
    super.key,
    required this.progress,
    required this.score,
    this.maxScore = 10,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.medium,
        ),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg(context),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border(context), width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Heart icon
            Container(
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: AppColors.circularBg(context),
                borderRadius: BorderRadius.circular(AppRadius.badge),
              ),
              child: Icon(
                Icons.heart_broken,
                color: AppColors.heartIcon, 
                size: 24,
              ),
            ),

            const SizedBox(width: AppSpacing.small),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Health Score',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.onPrimary(context),
                        ),
                      ),
                      Text(
                        '$score/$maxScore',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.onPrimary(context),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),

                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppRadius.progressBar,
                        ),
                        border: Border.all(
                          color: AppColors.border(context),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppRadius.progressBar,
                        ),
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(
                            AppRadius.progressBar,
                          ),
                          value: progress,
                          minHeight: 5,
                          backgroundColor: AppColors.scaffoldBg(context),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.healthBarActive,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
