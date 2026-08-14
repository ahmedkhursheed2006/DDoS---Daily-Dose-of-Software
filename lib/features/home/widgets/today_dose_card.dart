import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';

class TodayDoseCard extends StatelessWidget {
  final SeriesPost post;
  final VoidCallback onStart;
  const TodayDoseCard({super.key, required this.post, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentPeach,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Today's Dose",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryOrangeDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.seriesTitle.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 6),
          Text(post.postTitle, style: AppTextStyles.heading1),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(post.readTimeLabel, style: AppTextStyles.caption),
              const SizedBox(width: 12),
              const Icon(
                Icons.bar_chart,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(post.difficultyLabel, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Start Learning'),
            ),
          ),
        ],
      ),
    );
  }
}
