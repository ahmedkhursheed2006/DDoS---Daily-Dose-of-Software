import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';

class DailyPostCard extends StatelessWidget {
  final SeriesPost post;
  final VoidCallback onTap;
  const DailyPostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.seriesTitle.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(post.postTitle, style: AppTextStyles.heading2),
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
                      Text(
                        '· ${post.difficultyLabel}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (post.isRead)
              const Icon(Icons.check_circle, color: AppColors.success, size: 20)
            else
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
